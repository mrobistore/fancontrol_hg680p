#!/bin/sh

# Buat Direktori
echo "Membuat folder......"


# Clone repository
echo "Mengunduh file dari GitHub..."
git clone https://github.com/mrobistore/fancontrol_hg680p.git /tmp/fan_control

# Salin file ke lokasi yang sesuai
echo "Menyalin file konfigurasi..."
cp -r /tmp/fan_control/etc /etc
cp -r /tmp/fan_control/root /root
cp -r /tmp/fan_control/usr /usr

# Beri izin eksekusi pada file init dan script
chmod +x /etc/init.d/fan_control
chmod +x /root/fan_control.sh

# Tambahkan layanan fan_control ke startup
echo "Menambahkan layanan fan_control ke startup..."
/etc/init.d/fan_control enable
/etc/init.d/fan_control start

# Hapus file sementara
rm -rf /tmp/fan_control

echo "Instalasi selesai."
