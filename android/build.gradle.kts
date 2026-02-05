allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    fun applyNamespaceHack(p: Project) {
        val androidExtension = p.extensions.findByName("android")
        if (androidExtension != null) {
            try {
                val getNsMethod = androidExtension.javaClass.getMethod("getNamespace")
                val currentNs = getNsMethod.invoke(androidExtension)

                if (currentNs == null) {
                    val setNsMethod = androidExtension.javaClass.getMethod("setNamespace", String::class.java)
                    val safeGroup = if (p.group.toString().isNotEmpty()) p.group.toString() else "com.example.${p.name}"
                    setNsMethod.invoke(androidExtension, safeGroup)
                    println("PATCH APPLIQUÉ SUR : ${p.name}")
                }
            } catch (e: Exception) {
            }
        }
    }

    // On tente de planifier l'exécution
    try {
        project.afterEvaluate {
            applyNamespaceHack(this)
        }
    } catch (e: Exception) {
        applyNamespaceHack(project)
    }
}