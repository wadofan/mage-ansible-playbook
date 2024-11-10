# Ansible Playbook для SCIFiC

Проект призначений для автоматизованого налаштування новоствореного сервера, а також
завантаження і запуску на ньому [іншого](https://github.com/wadofan/mage-docker) проекта.


## Як користуватись цим плейбуком?

Для того, щоб запустити виконання плейбука, необхідно,
вказавши за потреби додаткові параметри та змінні 
(див. далі по тексту), виконати наступну команду:

```console
$ ansible-playbook ./playbook.yml
```

Крім цього, в проекті використовуються деякі колекції, що не входять 
в базову комплектацію Ansible (ansible-core). Тому перед виконанням
плейбука необхідно встановити їх за допомогою команди:

```console
$ ansible-galaxy collection install community.general community.docker
```


## Перелік змінних

Для ролі `system` використовується вього однa змінна:

- `ssh_service`: назва системного сервіса SSH, так 
як в різних системах його назва може відрізнятись
(за замовчуванням "`sshd`")


Роль `docker`, поки що, заточена під ОС Debian 12, 
у зв'язку з цим, змінні дозволяють визначити параметри, 
специфічні для цієї операційної системи.

| Змінна           | Опис |
| :--------------- | :--- |
| `debian_release` | Назва версії ОС Debian (наприклад, "`bookworm`") |
| `cpu_arch`       | Архітектура процесора (наприклад, "`amd64`") |
| `docker_keyfile` | Шлях до файлу, що містить GPG ключ Docker для пакетного менеджера Apt |
| `gpg_pkg`        | Назва пакету GnuPG (за замовчуванням "`gpg`")|


Для ролі `scific` використовуються наступні змінні:

| Змінна             | Опис |
| :----------------- | :--- |
| `docker_user_name` | Ім'я користувача, якого потрібно створити або додати до групи `docker` |
| `docker_user_pass` | Пароль для того ж користувача (у вигляді звичайного тексту, до нього буде застосований алгорим хешування SHA512) | 
| `docker_user_key`  | Публічни ключ SSH для доступу до того ж користувача |
| `local_keyfile`    | Шлях до файлу (на локальній машині, з якої запускається Ansible) з приватним ключем SSH для доступу до закритого GitHub репозиторію |
| `remote_keyfile`   | Шлях до файлу (на віддаленій машині, що налаштовується) з приватним ключем SSH для доступу до закритого GitHub репозиторію |
| `project_dir`      | Шлях до директорії, в яку потрібно склонувати репозиторій з Docker-проектом |
| `project_repo`     | URL репозиторія з Docker-проектом |
| `scific_repo`      | URL репозиторія вебсайту конференції SCIFiC |
| `git_pkg`          | Назва пакету Git (за замовчуванням "`git`") |
| `ssh_pkg`          | Назва пакету SSH-клієнта (за замовчуванням "openssh") |
| `cron_pkg`         | Назва пакету cron (за замовчуванням "`cron`") |
| `cron_service`     | Назва системного сервіса cron (за замовчуванням "`crond`") |


## Як можна задати ці параметри?

- у конфігураційному файлі `ansible.cfg` (або глобально в `/etc/ansible/ansible.cfg`, 
або в локальному файлі, приклад якого наданий в корені проекту як `ansible.cfg.example`);

- у файлі інвентарю зазвичай вказується список хостів (у вигляді IP-адрес або 
доменних імен), але там також можна вказати змінні для окремих хостів або
для групи. Аналогічно можна скористатись глобальним файлом `/etc/ansible/hosts` 
або локальним, приклад якого наданий в корені проекту як `inventory.example`;

- у файлах змінних (в даному проекті вони використовуються для ролей і розташовані
в директоріях за структурою `roles/<назва_ролі>/vars/main.yml`);

- безпосередньо під час виконання команди (за допомогою аргументів командного рядка).

