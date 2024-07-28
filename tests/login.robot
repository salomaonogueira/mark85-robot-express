*** Settings ***
Documentation        Cenários de autentificação do usuário

Library               Collections
Resource             ../resources/base.resource

Test Setup            Start Session
Task Teardown         Take Screenshot

*** Test Cases ***
Deve poder logar com um usuário pré-cadastrado

    ${user}        Create Dictionary
    ...            name=Salomão David
    ...            email=david@yahoo.com
    ...            password=teste@123

    Remove user from database        ${user}[email]
    Insert user from database        ${user}

    Submit login form                ${user}
    User should be logged in         ${user}[name]

Não deve logar com senha inválida
     ${user}        Create Dictionary
    ...            name=Angel Romero
    ...            email=romero@gmail.com
    ...            password=teste@123

    Remove user from database        ${user}[email]
    Insert user from database        ${user}

    Set To Dictionary                ${user}        password=abc123

    Submit login form                ${user}
    Notice should be                 Ocorreu um erro ao fazer login, verifique suas credenciais.
