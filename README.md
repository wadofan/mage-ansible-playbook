# Ansible Playbook для SCIFiC

Проект призначений для автоматизованого налаштування новоствореного сервера, а також
завантаження і запуску на ньому [іншого](https://github.com/wadofan/mage-docker) проекта.


## Як користуватись цим плейбуком?

Варто зазначити, що в проекті використовуються деякі колекції,
що не входять в базову комплектацію Ansible (ansible-core). Їх
необхідно встановити перед виконанням плейбука.

```console
$ git clone git@github.com:wadofan/mage-ansible-playbook.git
$ cd mage-ansible-playbook
$ ansible-galaxy collection install  ansible.posix community.general community.docker
```

Плейбук був розділений на дві частини: `init.yml` та `run.yml`.
`init.yml` виконує початкове налаштування системи і призначений,
в основному, для запуску його за допомогою Terraform/Opentofu.
`run.yml`, в свою чергу призначений для завантаження і запуску 
[іншого проекту](https://github.com/wadofan/mage-docker).

Отже, для того, щоб запустити виконання плейбука, 
необхідно, вказавши за потреби додаткові параметри 
та змінні (див. далі по тексту), виконати наступну 
команду:

```console
$ ansible-playbook ./init.yml ./run.yml
```


## Перелік змінних

Крім змінних, що використовуються у ролях
і будуть розглянуті нижче, існують також
групові змінні що знаходяться у файлі
`group_vars/all/vars.yml` і використовуються
для всього проекту.

| Назва                | Опис                                           |
| :------------------- | :--------------------------------------------- |
| `project_user_name`  | Ім'я користувача, для нової системи            |
| `project_user_pass`  | Пароль для доступу до того ж  користувача      |
| `project_user_shell` | Командний інтерпритатор для того ж користувача |
| `project_user_key`   | SSH ключ для доступу до того ж користувача     |
| `project_dir`        | Директорія для завантантаження проекта         |

Роль `system` призначення для початкового налаштування
операційної системи на новому сервері: оновлення і
встановлення пакетів, а також для створення коритувача.

Для цього використовуються такі змінні:

| Назва      | Опис                                           |
| :--------- | :--------------------------------------------- |
| `gpg_pkg`  | Назва пакета GnuPG (за замовчуванням "`gpg`")  |
| `cron_pkg` | Назва пакета cron  (за замовчуванням "`cron`") |
| `sudo_pkg` | Назва пакета sudo  (за замовчуванням "`sudo`") |

Роль `docker` призначена для встановлення Docker і поки що,
заточена під ОС Debian 12, у зв'язку з цим, вона містить
змінні, що дозволяють визначити специфічні для цієї операційної
системи параметри:

| Змінна               | Опис                                             |
| :------------------- | :----------------------------------------------- |
| `debian_release`     | Назва версії ОС Debian (наприклад, "`bookworm`") |
| `cpu_arch`           | Архітектура процесора (наприклад, "`amd64`")     |
| `apt_docker_keyfile` | Шлях до файлу, що повинен містити GPG ключ Docker для пакетного менеджера Apt |

Роль `harden` призначенна забезпечення базової безпеки
на нових серверах, а саме: налаштування демона SSH,
встановлення і налаштування брендмауера (був обраний `ufw`),
а також блокування доступу до облікового запису користувача `root`.

| Змінна        | Опис                                         |
| :------------ | :------------------------------------------- |
| `ufw_pkg`     | Назва пакета UFW (за замовчуванням "`ufw`")  |
| `ssh_service` | Назва сервіса SSH (за замовчуванням "`sshd`")|

Для завантаження і запуску проекта була створена
роль `scific`. Вона використовує наступні змінні:

| Змінна                 | Опис |
| :--------------------- | :--- |
| `git_pkg`              | Назва пакета Git (за замовчуванням "`git`")             |
| `ssh_pkg`              | Назва пакета SSH-клієнта (за замовчуванням "`openssh`") |
| `local_keyfile`        | Шлях до файлу (на локальній машині) з приватним ключем SSH для доступу до закритого GitHub репозиторію  |
| `remote_keyfile`       | Шлях до файлу (на віддаленій машині) з приватним ключем SSH для доступу до закритого GitHub репозиторію |
| `project_repo`         | URL репозиторія з Docker-проектом  |
| `website_repo`         | URL репозиторія з файлами вебсайту |
| `cron_service`         | Назва сервіса cron (за замовчуванням "`crond`")        |
| `cron_file`            | Назва для файлу із задачами cron |
| `nginx_container_name` | Назва контейнера Nginx           |
| `letsencrypt_email`    | електрона пошта, на яку буде зареєстрований сертифікат |
| `letsencrypt_domain`   | доменне ім'я, на яке буде виданий сертифікат           |


## Як можна задати ці параметри?

- у конфігураційному файлі `ansible.cfg` (або глобально в `/etc/ansible/ansible.cfg`,
або в локальному файлі, приклад якого наданий в корені проекту як `ansible.cfg.example`);

- у файлі інвентарю зазвичай вказується список хостів (у вигляді IP-адрес або
доменних імен), але там також можна вказати змінні для окремих хостів або
для групи. Аналогічно можна скористатись глобальним файлом `/etc/ansible/hosts`
або локальним, приклад якого наданий в корені проекту як `inventory.example`;

- у файлах змінних;

- безпосередньо під час виконання команди (за допомогою аргументів командного рядка).

Також варто згадати, що деякі змінні задаються за допомогою змінних середовища. 
Можна задати ці змінні у вашому середовищі, хоча це не обов'язково і за бажанням 
можна змінити їх напряму у файлах. Наприклад, у файлі `group_vars/all/vars.yml`:
- `MAGE_PASS` задає змінну `project_user_pass`,
- `MAGE_EMAIL` задає змінну `letsencrypt_email`,
- `MAGE_DOMAIN` задає змінну `letsencrypt_domain`.

