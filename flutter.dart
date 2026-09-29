Kalau emulator sudah pernah dibuat dan tinggal menjalankan:

flutter emulators
flutter emulators --launch Medium_Phone
flutter devices
flutter run -d emulator-5554
❌ Kalau emulator tidak muncul

Coba:

flutter devices

Kalau emulator tidak ada, cek ADB dengan path yang sebelumnya kita gunakan:

& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" devices

Kalau muncul:

emulator-5554    offline

restart ADB:

& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" kill-server
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" start-server

Lalu:

& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" devices

Kemudian cek lagi:

flutter devices
🛑 Kalau mau menghentikan Flutter

Saat aplikasi sedang berjalan di terminal:

q

atau tekan:

Ctrl + C