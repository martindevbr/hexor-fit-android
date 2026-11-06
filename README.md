# Hexor Fit para Android

App Android leve (menos de 1 MB) do [Hexor Fit](https://fit.hexor.com.br). É uma
**Trusted Web Activity (TWA)**: abre o próprio site em tela cheia pelo Chrome do
aparelho, sem barra de endereço. Por isso o conteúdo está sempre atualizado: o que
muda no site muda no app, sem nova versão.

- Pacote: `br.com.hexor.fit`
- Abre em: `https://fit.hexor.com.br/inicio?app=android&v=<versão>`
  - personal logado vai para o painel (`/app`);
  - aluno logado vai para a área do aluno (`/aluno`);
  - senão, a tela "Sou aluno / Sou personal".
- Atalhos (toque longo no ícone): "Minha área de aluno" e "Painel do personal".
- Links do site (ex.: a ficha que o personal manda no WhatsApp) podem abrir direto no app.
- Sem Chrome (ou outro navegador com TWA): abre numa Custom Tab. WebView não é usado
  porque o login com Google não funciona dentro dele.

## Download

Sempre a última versão:

https://github.com/martindevbr/hexor-fit-android/releases/latest/download/hexor-fit.apk

O site mostra esse link no aviso "Tem app do Hexor Fit para Android" e, dentro do app,
avisa "Nova versão do app disponível" quando a versão instalada for menor que
`ANDROID_APP_VERSION` em `lib/app-version.ts` do site.

## Estrutura

```
app/build.gradle                 versão, URL de entrada, assinatura (por variáveis de ambiente)
app/src/main/AndroidManifest.xml TWA (androidbrowserhelper), cores, splash, atalhos, links
app/src/main/res/                ícones (gerados do H da marca), cores, splash
twa-manifest.json                resumo da configuração no formato do Bubblewrap
.github/workflows/release.yml    build assinado + GitHub Release
store/icone-512.png              ícone grande (loja/divulgação)
```

## Nova versão (release)

1. Crie a tag e envie:
   ```
   git tag v1.0.1
   git push origin v1.0.1
   ```
   (ou rode o workflow **Release do app Android** pela aba Actions, informando a versão).
2. O GitHub Actions monta `hexor-fit.apk` e `hexor-fit.aab` assinados e publica a Release.
3. No site, suba `ANDROID_APP_VERSION` em `lib/app-version.ts` para a mesma versão:
   quem tem o app antigo passa a ver o aviso de atualização.

`versionCode` sai da versão: `1.2.3` vira `10203`.

## Secrets do repositório (Settings > Secrets and variables > Actions)

| Secret | O que é |
|---|---|
| `KEYSTORE_BASE64` | a keystore `.jks` em base64 |
| `KEYSTORE_PASSWORD` | senha da keystore |
| `KEY_ALIAS` | apelido da chave (`hexorfit`) |
| `KEY_PASSWORD` | senha da chave |

A keystore **nunca** entra no repositório. Ela fica fora dele (no PC do Martin, em
`D:\hexor-fit-android-keys\`). Perder a keystore = não dá mais para atualizar o app por
cima (quem tem instalado teria de desinstalar). Guarde uma cópia segura.

## Digital Asset Links

Para abrir sem barra de endereço, o site publica
`https://fit.hexor.com.br/.well-known/assetlinks.json` com o SHA-256 do certificado
de assinatura (`app/.well-known/assetlinks.json/route.ts` no repositório do site).
Se trocar a keystore, atualize lá.

Conferir o SHA-256 de um APK:

```
apksigner verify --print-certs hexor-fit.apk
```

## Build local

Requisitos: JDK 17 ou 21 e Android SDK (platform 36).

```
# Windows (PowerShell), com as variáveis de usuário já criadas:
$env:HEXOR_FIT_KEYSTORE = "D:\hexor-fit-android-keys\hexor-fit.jks"
.\gradlew.bat assembleRelease bundleRelease "-PappVersion=1.0.0"
```

As senhas vêm de `HEXOR_FIT_KEYSTORE_PASSWORD`, `HEXOR_FIT_KEY_PASSWORD` e
`HEXOR_FIT_KEY_ALIAS`. Sem `HEXOR_FIT_KEYSTORE` o APK de release sai sem assinatura.
Saída: `app/build/outputs/apk/release/app-release.apk`.
