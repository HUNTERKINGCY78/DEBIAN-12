# Gunakan image Debian 12 sebagai dasar
FROM debian:12

# Perbarui sistem dan instal dependensi yang diperlukan
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-terminal tightvncserver novnc websockify supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Buat direktori untuk supervisord
RUN mkdir -p /var/log/supervisor

# Salin file supervisord.conf ke dalam container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Tetapkan port VNC dan noVNC
EXPOSE 5901 8080

# Buat user untuk menjalankan sesi desktop
RUN useradd -m -s /bin/bash dockeruser && \
    echo "dockeruser:password" | chpasswd

# Tetapkan user default
USER dockeruser
ENV USER=dockeruser

# Jalankan perintah untuk memulai supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
