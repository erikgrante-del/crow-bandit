# Crow Bandit — совместная разработка без Team Create

Общий проект **Crow Bandit** (group *Last Light: Industries*, universe `10773637194`).
Каждый правит свою копию в **своём** Roblox Studio; файлы синкаются через **Argon**,
обмен идёт через **Git** (репозиторий ниже).

> Team Create («живая коллаборация») отключён специально — он и вызывал ошибку
> `TeamCreateJoinFailedSafetyChecks` для региона РФ. Здесь та же задача решается иначе.

**Репозиторий:** https://github.com/erikgrante-del/crow-bandit (public)

---

## Одна кнопка

### Ты (у тебя уже всё склонировано)

Просто запусти **`Start.bat`** (или ярлык *Crow Bandit* на рабочем столе).

### Друг (первый раз)

```
git clone https://github.com/erikgrante-del/crow-bandit
cd crow-bandit
Start.bat
```

Больше ничего. `Start.bat` сам:
1. поставит Argon и плагин (если их нет),
2. поднимет Argon-сервер,
3. включит авто-pull/push,
4. откроет место **Crow Bandit** в Roblox Studio.

Git нужен один раз: если его нет — поставь **GitHub Desktop**
(`https://desktop.github.com`) или `winget install --id Git.Git -e`.

---

## Как это работает

```
Ты:   файлы ─Argon─► твоя Studio
Друг: файлы ─Argon─► его Studio
       ▲                   ▲
       └──── Git/GitHub ───┘
```

- Правишь файл → Argon мгновенно кладёт его в твою Studio.
- `scripts/autosync.ps1` каждые 5 секунд делает `commit` → `pull` → `push`.
- У второго изменения появляются автоматически через пару секунд.

Реальную синхронность (курсоры друг друга) это не даёт — но совместную работу даёт.

---

## Структура

```
Start.bat                       ← запуск одной кнопкой
scripts/install-argon.ps1       ← установка Argon (вызывается из Start.bat)
scripts/autosync.ps1            ← авто pull/push
default.project.json            ← карта «папка → сервис Roblox»
argon.toml                      ← настройки Argon
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

Именование скриптов: `Name.server.luau` → `Script`, `Name.client.luau` → `LocalScript`,
`Name.luau` → `ModuleScript`.

---

## Роли: арт vs скрипты

Разделение «один делает модели/анимации/VFX, другой пишет скрипты» — рабочее и удобное,
потому что вы почти не трогаете одни и те же вещи → конфликтов почти не бывает.

Что важно знать:

- **Скрипты** — чистый текст, сливаются Git автоматически. Идеально.
- **Модели / VFX / анимации** — это объекты в DataModel. Argon (двусторонний синк) пишет
  их в файлы и отдаёт второй стороне. Но Git **не умеет** аккуратно сливать такие файлы:
  если вы оба правите **одну и ту же** модель — будет конфликт, разводить руками.
- **Текстуры/меши/анимации** как ассеты заливаются на Roblox (в группу) и превращаются в
  `rbxassetid` — в файлах хранятся только ссылки, сами картинки остаются в облаке Roblox.
- **Террейн** через Git почти не синкается — его лучше править одному человеку.
- Если репозиторий сильно раздуется от бинарных моделей — можно включить **Git LFS**.

Проще всего: **ты владеешь Workspace/артом, друг — сервисами скриптов**. Тогда каждый
правит свою зону и конфликтов нет.

---

## Полезно

- Если `git push` ругается на соединение — у тебя системный прокси `127.0.0.1:10809`,
  запусти своё приложение-прокси.
- Argon-плагин в Studio: вкладка **Argon**. Настройки — шестерёнка в его окне.
