# ssh-docker

Esta imagen permite agregar usuarios a hosts donde corre docker media contenedores, y agregara las claves publicas que tendrán permitido conectarse a este host con este usuario.
Las claves publicas son descargadas mediante la especificación de una URL y, en caso de que el usuario exista, solo agregara las claves publicas(mas las existentes) a este usuario.

Para su correcto funcionamiento se deben tener en cuenta los siguientes volúmenes y variables de ambiente.

### Volúmenes

* /etc: se debe mapear el directorio /etc del host al directorio /etc del contenedor.
* /home: se debe mapear el directorio /home del host al directorio /home del contenedor.

### Variables de ambiente

* SSH_USER: usuario nuevo/existente al que se le agregaran las claves publcias descargadas.
* SSH_URL_KEYS: URL desde donde se descargaran las claves publicas.

Opcionalmente se puede definir la variable SSH_USER_GROUP, permite agregar el usuario a un grupo existente del sistema.


Ejemplo de ejecución:
```bash
docker run --rm -it \
        -e SSH_USER=mikro \
        -e SSH_URL_KEYS=https://mikroways.net/public_keys_mw.txt \
        -v /etc:/etc \
        -v /home:/home \
        registry.gitlab.com/mikroways/ssh-docker:tag
```
