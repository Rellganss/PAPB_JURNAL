# Mengabaikan anotasi javax.annotation
-keep class javax.annotation.** { *; }
-dontwarn javax.annotation.**

# Mengabaikan anotasi error-prone
-keep class com.google.errorprone.annotations.** { *; }
-dontwarn com.google.errorprone.annotations.**
