
kasi sensor suhu (ubah jika berbeda)
TEMP_SENSOR="/sys/class/thermal/thermal_zone0/temp"

# Lokasi GPIO untuk kipas
GPIO_PATH="/sys/class/gpio/gpio507"

# Baca konfigurasi dari UCI
TARGET_TEMP_MIN=$(uci get fan.settings.temp_min)000  # Minimal suhu (milicelsius)
TARGET_TEMP_MAX=$(uci get fan.settings.temp_max)000  # Maksimal suhu (milicelsius)

# Waktu delay (dalam detik)
DELAY_SECONDS=$(uci get fan.settings.delay_seconds)

# Pastikan GPIO terkonfigurasi
if [ ! -d "$GPIO_PATH" ]; then
    echo "507" > /sys/class/gpio/export
    echo "out" > "$GPIO_PATH/direction"
fi

# Fungsi untuk membaca suhu
get_temperature() {
    cat "$TEMP_SENSOR"
}

# Variabel untuk melacak waktu suhu tinggi
high_temp_start=0

# Loop kontrol kipas
while true; do
    CURRENT_TEMP=$(get_temperature)  # Baca suhu saat ini
    CURRENT_TIME=$(date +%s)        # Dapatkan waktu saat ini (epoch time)

    # Debugging (opsional, hapus jika tidak diperlukan)
    echo "Suhu saat ini: $((CURRENT_TEMP / 1000))°C"

    if [ "$CURRENT_TEMP" -ge "$TARGET_TEMP_MAX" ]; then
        if [ "$high_temp_start" -eq 0 ]; then
            high_temp_start=$CURRENT_TIME
        fi

        # Periksa apakah suhu tinggi bertahan selama DELAY_SECONDS
        if [ $((CURRENT_TIME - high_temp_start)) -ge "$DELAY_SECONDS" ]; then
            echo 1 > "$GPIO_PATH/value"  # Hidupkan kipas
            logger -t "FAN_CONTROL" "Suhu: $((CURRENT_TEMP / 1000))°C, Kipas: ON"
        fi
    else
        # Reset jika suhu kembali normal
        high_temp_start=0
        if [ "$CURRENT_TEMP" -le "$TARGET_TEMP_MIN" ]; then
            echo 0 > "$GPIO_PATH/value"  # Matikan kipas
            logger -t "FAN_CONTROL" "Suhu: $((CURRENT_TEMP / 1000))°C, Kipas: OFF"
        fi
    fi

    # Tunggu 5 detik sebelum membaca ulang
    sleep 5
done
