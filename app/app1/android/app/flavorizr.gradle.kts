import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.example.app1.dev"
            resValue(type = "string", name = "app_name", value = "App1 DEV")
        }
        create("preprod") {
            dimension = "flavor-type"
            applicationId = "com.example.app1.preprod"
            resValue(type = "string", name = "app_name", value = "App1 PREPROD")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.example.app1"
            resValue(type = "string", name = "app_name", value = "App1")
        }
    }

    buildFeatures.resValues = true
}