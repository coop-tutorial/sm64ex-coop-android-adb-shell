#!/bin/bash

# Definición de colores
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

# Función para imprimir mensajes en color amarillo
function print_yellow {
    echo -e "${YELLOW}$1${NC}"
}

# Actualización de paquetes en Termux
print_yellow "Actualizando paquetes en Termux..."
print_yellow "Créditos: Retired64 on YouTube..."
pkg update -y &>/dev/null && pkg upgrade -y &>/dev/null
print_yellow "Paquetes actualizados."

# Instalación de android-tools
print_yellow "Instalando android-tools..."
pkg install android-tools -y &>/dev/null
print_yellow "android-tools instalado."

# Instrucciones para la depuración inalámbrica
print_yellow "Configurando la depuración inalámbrica..."

# Ingresar la IP y el puerto para emparejar
read -p "Ingrese la IP y el puerto para emparejar (formato: ip:puerto): " IP_PORT
print_yellow "Emparejando con $IP_PORT..."
adb pair $IP_PORT

# Conectar el dispositivo
read -p "Ingrese la IP y el puerto para conectar (formato: ip:puerto): " CONNECT_IP_PORT
print_yellow "Conectando con $CONNECT_IP_PORT..."
adb connect $CONNECT_IP_PORT

# Verificar la conexión
print_yellow "Verificando la conexión..."
adb devices | grep 'device$' &>/dev/null

if [ $? -eq 0 ]; then
    print_yellow "Conexión exitosa. Dispositivos conectados:"
    adb devices

    # Ejecutar comandos adb shell
    print_yellow "Ejecutando comandos adb shell..."
    adb shell "/system/bin/device_config set_sync_disabled_for_tests persistent"
    adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
    adb shell "settings put global settings_enable_monitor_phantom_procs false"
    adb shell "setprop persist.sys.fflag.override.settings_enable_monitor_phantom_procs false"
    print_yellow "Comandos ejecutados exitosamente."
else
    print_yellow "Error en la conexión. No se encontraron dispositivos conectados."
fi