# A androidbrowserhelper acha várias classes dela por nome/ComponentName em tempo de execução
# (ex.: ManageDataLauncherActivity). Renomear quebra o app (fechava ao abrir na 1.0.1).
-keep class com.google.androidbrowserhelper.** { *; }
