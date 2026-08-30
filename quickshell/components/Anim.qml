import QtQuick

NumberAnimation {
    enum Type {
        StandardSmall = 0,
        Standard,
        StandardLarge,
        StandardExtraLarge,
        EmphasizedSmall,
        Emphasized,
        EmphasizedLarge,
        EmphasizedExtraLarge,
        FastSpatial,
        DefaultSpatial,
        SlowSpatial,
        FastEffects,
        DefaultEffects,
        SlowEffects
    }

    property int type: Anim.DefaultSpatial

    duration: {
        if (type === Anim.FastSpatial)
            return Tokens.anim.durations.expressiveFastSpatial;
        if (type === Anim.DefaultSpatial)
            return Tokens.anim.durations.expressiveDefaultSpatial;
        if (type === Anim.SlowSpatial)
            return Tokens.anim.durations.expressiveSlowSpatial;
        if (type === Anim.FastEffects)
            return Tokens.anim.durations.expressiveFastEffects;
        if (type === Anim.DefaultEffects)
            return Tokens.anim.durations.expressiveDefaultEffects;
        if (type === Anim.SlowEffects)
            return Tokens.anim.durations.expressiveSlowEffects;

        if (type >= Anim.EmphasizedSmall && type <= Anim.EmphasizedExtraLarge)
            return Tokens.anim.durations.large;
        return Tokens.anim.durations.normal;
    }
    easing: {
        if (type === Anim.FastSpatial || type === Anim.DefaultSpatial || type === Anim.SlowSpatial)
            return Tokens.anim.expressiveDefaultSpatial;
        if (type === Anim.FastEffects || type === Anim.DefaultEffects || type === Anim.SlowEffects)
            return Tokens.anim.expressiveDefaultEffects;
        if (type >= Anim.EmphasizedSmall && type <= Anim.EmphasizedExtraLarge)
            return Tokens.anim.emphasized;
        return Tokens.anim.standard;
    }
}
