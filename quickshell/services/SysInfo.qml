pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// Lightweight system statistics (CPU + RAM) sampled from /proc, plugin-free
// (no vitsy / libstatgrab dependency). Sampled on an interval to stay cheap.
Singleton {
    id: root

    readonly property int intervalMs: 2000

    property real cpu: 0          // 0..1
    property real memUsed: 0      // bytes
    property real memTotal: 0     // bytes
    property real diskUsed: 0     // bytes
    property real diskTotal: 0    // bytes

    readonly property real memFrac: root.memTotal > 0 ? root.memUsed / root.memTotal : 0
    readonly property real diskFrac: root.diskTotal > 0 ? root.diskUsed / root.diskTotal : 0

    property var lastCpu: null

    function parseCpu(line: string): var {
        // "cpu  user nice system idle iowait irq softirq steal ..."
        const parts = line.trim().split(/\s+/).map(Number);
        const idle = (parts[4] ?? 0) + (parts[5] ?? 0);
        let total = 0;
        for (let i = 1; i < parts.length; i++)
            total += parts[i];
        return { idle, total };
    }

    function onCpuRead(text: string): void {
        const line = text.split("\n")[0] ?? "";
        if (!line.startsWith("cpu "))
            return;
        const cur = root.parseCpu(line);
        if (root.lastCpu) {
            const dTotal = cur.total - root.lastCpu.total;
            const dIdle = cur.idle - root.lastCpu.idle;
            if (dTotal > 0)
                root.cpu = Math.max(0, Math.min(1, 1 - (dIdle / dTotal)));
        }
        root.lastCpu = cur;
    }

    function onMemRead(text: string): void {
        let total = 0, avail = 0;
        for (const l of text.split("\n")) {
            if (l.startsWith("MemTotal:"))
                total = parseFloat(l.split(/\s+/)[1] ?? "0");
            else if (l.startsWith("MemAvailable:"))
                avail = parseFloat(l.split(/\s+/)[1] ?? "0");
        }
        root.memTotal = (total || 0) * 1024;
        root.memUsed = (total - avail) * 1024;
    }

    function onDiskRead(text: string): void {
        const lines = text.trim().split("\n");
        if (lines.length < 2)
            return;
        const parts = lines[1].trim().split(/\s+/);
        root.diskTotal = (parseFloat(parts[1] ?? "0") || 0) * 1024;
        root.diskUsed = (parseFloat(parts[2] ?? "0") || 0) * 1024;
    }

    Timer {
        id: poll
        interval: root.intervalMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            diskProc.running = true;
        }
    }

    Process {
        id: cpuProc
        running: false
        command: ["sh", "-c", "head -n1 /proc/stat"]
        stdout: StdioCollector {
            onStreamFinished: root.onCpuRead(text)
        }
    }

    Process {
        id: memProc
        running: false
        command: ["sh", "-c", "grep -E 'MemTotal|MemAvailable' /proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: root.onMemRead(text)
        }
    }

    Process {
        id: diskProc
        running: false
        command: ["sh", "-c", "df -B1 / | tail -n1"]
        stdout: StdioCollector {
            onStreamFinished: root.onDiskRead(text)
        }
    }
}
