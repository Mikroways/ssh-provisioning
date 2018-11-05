#!/bin/sh

#Chequeo de parametros
if [ -z "$SSH_USER" ] || [ -z "$SSH_URL_KEYS" ] ; then
  echo "Deben especificarse las siguientes variables: SSH_USER y SSH_URL_KEYS"
  exit 123
fi
#Fin de chequeo de parametros

USERNAME=${SSH_USER}
URL=${SSH_URL_KEYS}
UGROUP=${SSH_USER_GROUP:-''}

# Si el usuario no existe, debe ser creado
# Faltaria ver la opcion de la contraseña, quizas lo mejor sea crear una aleatoria
getent passwd $USERNAME >/dev/null 2>&1
if [ $? -ne 0 ]; then
  adduser $USERNAME -s /bin/ash -h /home/$USERNAME -D

  #Agrego una contrase�a random al usuario
  echo $USERNAME:$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 32 | head -n 1) | chpasswd >/dev/null 2>&1

  #Si la variable UGROUP tiene contenido, se debe agregar al grupo indicado
  [[ ! -z "$UGROUP" ]] && adduser $USERNAME $UGROUP

fi

#Inicializo directorio de .ssh, puede suceder que este no exista
if [ ! -d "/home/$USERNAME/.ssh" ]; then
  mkdir -p /home/$USERNAME/.ssh
  touch /home/$USERNAME/.ssh/authorized_keys
  chown -R $USERNAME: /home/$USERNAME/.ssh
fi

#Dentro de cada home, de cada usuario, se encuentra un arhchivo con el contenido de authorized_keys original
if [ ! -f /home/$USERNAME/.ssh/authorized_keys-original ]; then
  cp -a /home/$USERNAME/.ssh/authorized_keys /home/$USERNAME/.ssh/authorized_keys-original
fi

#Descargar claves que se encuentran en URL
wget -O /tmp/new-keys.txt $URL >/dev/null 2>&1

#Ya tengo 2 archivos con las claves ssh necesarias: 
# Las claves original en el equipo: /home/$USERNAME/.ssh/authorized_keys-original
# Las nuevas claves que seran agregadas: /tmp/new-keys.txt
# El resultado sera el contenido de estos dos archivos en el archivo: /home/$USERNAME/.ssh/authorized_keys

cat /home/$USERNAME/.ssh/authorized_keys-original > /home/$USERNAME/.ssh/authorized_keys

cat /tmp/new-keys.txt >> /home/$USERNAME/.ssh/authorized_keys
