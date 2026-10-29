# Crow Bandit — совместная разработка без Team Create

Это общий проект **Crow Bandit** (group *Last Light: Industries*, universe `10773637194`).
Работаем так: каждый правит свою копию в **своём** Roblox Studio, файлы синхронятся через
**Argon**, а обмен изменениями идёт через **Git**.

> Team Create («живая коллаборация») отключён специально — именно он вызывал ошибку
> `TeamCreateJoinFailedSafetyChecks` для региона РФ. Теперь та же задача решается иначе,
> и зависит она уже не от серверов Roblox, а только от нас.

## Что поставить один раз

| Инструмент | Зачем |
|---|---|
| **Git** | обмен изменениями с другом |
| **Argon** | синхронизация файлов ↔ Studio (+ плагин в Studio) |

На Windows проще всего: запусти **`setup.bat`** — он поставит Argon и плагин сам.
Git, если его нет, поставь из GitHub Desktop (`https://desktop.github.com`) или
`winget install --id Git.Git -e`.

## Первый запуск (для тебя — владельца)

1. Создай пустой репозиторий на GitHub (например, `crow-bandit`), **не** добавляй README.
2. В этой папке:
   ```
   git remote add origin https://github.com/<ты>/crow-bandit.git
   git branch -M main
   git push -u origin main
   ```
3. Открой место **Crow Bandit** в Studio, запусти `sync.bat`, в Studio нажми **Argon → Connect**.

## Первый запуск (для соавтора)

1. `git clone https://github.com/<ты>/crow-bandit.git`
2. `setup.bat` (один раз).
3. Открыть место **Crow Bandit** в Studio.
4. `sync.bat` → в Studio **Argon → Connect**.

## Ежедневная работа

- Пишешь код → сохраняешь файл. Argon мгновенно кладёт его в твою Studio.
- `sync.bat` каждые 5 секунд сам делает `git commit` + `git pull` + `git push`.
- У друга изменения появляются в Studio максимум через несколько секунд.

Ничего нажимать не надо: один раз запустил `sync.bat` — и всё едет само.

## Структура

```
default.project.json            ← карта «папка → сервис Roblox»
argon.toml                      ← настройки Argon
setup.bat / sync.bat            ← установка и запуск синка
scripts/autosync.ps1            ← авто pull/push
src/
  ReplicatedStorage/            → ReplicatedStorage
  ServerScriptService/          → ServerScriptService
  ServerStorage/                → ServerStorage
  StarterGui/                   → StarterGui
  StarterPack/                  → StarterPack
  StarterPlayer/
    StarterPlayerScripts/       → StarterPlayer.StarterPlayerScripts
    StarterCharacterScripts/    → StarterPlayer.StarterCharacterScripts
```

Скрипты: `Name.server.luau` → `Script`, `Name.client.luau` → `LocalScript`,
`Name.luau` → `ModuleScript`. Модели можно хранить как `.rbxmx`.

## Важно (чтобы не разводить конфликты)

- **Не редактируйте один и тот же скрипт одновременно.** Для остального Git сливает сам.
- **Террейн** и бинарные модели через Git мутно — их лучше править по одному человеку.
- Если `autosync` написал про конфликт — разреши его руками в Git и запусти `sync.bat` заново.
- Хочешь поиграться с настройками Argon — вкладка **Argon** в Studio → шестерёнка.
  Двусторонний синк включён: что сделал в Studio, то уезжает в файлы.
