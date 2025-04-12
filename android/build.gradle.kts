val kotlin_version = "2.1.20"

plugins {
    id("com.google.gms.google-services") version "4.3.15" apply false
//    id("org.jetbrains.kotlin.android") version "2.1.20"
//    id("com.android.application")
//    id("org.jetbrains.kotlin.android' version '2.1.20")
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Classpath dependencies go here
        classpath("com.android.tools.build:gradle:8.1.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.20")
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }

}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

