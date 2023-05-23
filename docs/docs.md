catalunha@pop-os:~/myapp$ flutter create --project-name=agendarep --org to.brintec --platforms android,web ./agendarep

cd ~/myapp/agendarep && flutter build web --dart-define=keyApplicationId=VtcsOwYidKPYKz4gTXbLELZXEiu0s5xbo4JGu3wJ --dart-define=keyClientKey=glVe7bAt5ve2fbPFUOyridy8goa21Ch9jMA0hR1i  && cd back4app/agendarep/ && b4a deploy

joelberparriao@gmail.com
J@elber81

https://dartcode.org/docs/using-dart-define-in-flutter/

# reuniao do dia 20230416
retirar email da secretaria
colocar infos sobre telefone
bloquear clinic sem medico.
pq nao buscou dados do end do medico ao listar medido e editar o medico.
Nao veio a especialidade do adriando quando cadastrou a agenda dele.
bloquear a escolha de esp e consultorio na agenda. que nao sejam ja cadastrados.
retirar geopoint



# gou router
https://www.youtube.com/watch?v=W8d-2acPXKA
https://www.youtube.com/watch?v=IqT4AfogjOA


# dart define
https://dartcode.org/docs/using-dart-define-in-flutter/
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "name": "agendarep",
      "request": "launch",
      "type": "dart",
      
    },
    {
      "name": "agendarep (profile mode)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "profile"
    },
    {
      "name": "agendarep (release mode)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "release"
    }
  ]
}