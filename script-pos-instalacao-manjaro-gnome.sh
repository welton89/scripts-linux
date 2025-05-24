#!/bin/bash

# Arquivo de log
log_file="instalacao_pacotes.log"

# Função para registrar mensagens no log e exibi na tela
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
  echo "$log_file"
}

# tratar erros e continuar
error_handler() {
  local mensagem="$1"
  log "Erro: $mensagem"
  echo "Erro: $mensagem" >&2 # Mostra o erro na tela (stderr)
}

# Atualizar o sistema
echo "Insira sua senha root para iniciar"
echo "                            |"
echo "                            |"
echo "                            |"
echo "                            |"
echo "                            V"
echo "                          "
if ! sudo pacman -Syu --noconfirm; then
  error_handler "Falha ao atualizar o sistema."
log "Atualizando o sistema..."
fi
log "Sistema atualizado."

# lista de pacotes do repositório oficial
pacotes_oficiais=(
  telegram-desktop
  discord
  vlc
  steam
  gnome-system-monitor
  qbittorrent
  gnome-boxes
  obs-studio
  inkscape
  krita
  python-pip
  python-pipenv
  python-pipenv-to-requirements
  code
)

log "Instalando pacotes do repositório oficial: ${pacotes_oficiais[*]}"
# instala pacotes oficiais
for pacote in "${pacotes_oficiais[@]}"; do
  log "Instalando $pacote..."
  if ! sudo pacman -S --needed --noconfirm "$pacote"; then
    error_handler "Falha ao instalar $pacote."
  else
    log "$pacote instalado com sucesso."
fi
done

# Instalar Docker
log "Instalando Docker..."
if ! sudo pacman -S --needed --noconfirm docker docker-compose; then
  error_handler "Falha ao instalar Docker."
else
  if ! sudo systemctl enable docker; then
    error_handler "Falha ao habilitar o serviço Docker."
  fi
  if ! sudo systemctl start docker; then
    error_handler "Falha ao iniciar o serviço Docker."
  fi
    if ! sudo usermod -aG docker $USER; then
    error_handler "Falha ao add permissões ao Docker."
  fi
    if ! newgrp docker; then
    error_handler "Falha ao ativa configurações ao docker."
  fi
  log "Docker instalado e configurado."
fi

# Instalar pacotes Flatpak
pacotes_flatpak=(
  app.zen_browser.zen
  com.github.vikdevelop.photopea_app
  org.gabmus.gfeeds
  com.github.xournalpp.xournalpp
  org.kde.umbrello
  rest.insomnia.Insomnia
)

log "Instalando pacotes Flatpak: ${pacotes_flatpak[*]}"
for pacote in "${pacotes_flatpak[@]}"; do
  log "Instalando $pacote..."
  if ! flatpak install --noninteractive flathub "$pacote"; then
    error_handler "Falha ao instalar $pacote (Flatpak)."
  else
    log "$pacote (Flatpak) instalado com sucesso."
fi
done
log "Instalação concluída!"

# Pergunta para reiniciar
read -p "Reiniciar o sistema agora? (s/n): " reiniciar
if [[ "$reiniciar" == "s" ]]; then
  echo "Sabia escolha meu jovem!!!"
  sleep 2
  log "Reiniciando o sistema..."
  sleep 2
  sudo reboot
fi
sleep 2
log "Terminamos aqui!!!"
echo "Tchau!!"
sleep 2
echo "Até mais ver!!!"
sleep 2
echo "Vou sentir saudades."
sleep 2
echo "Por favor não vá."
sleep 2
echo "Ta bem, Parei. Agora eu fui..."
sleep 2

