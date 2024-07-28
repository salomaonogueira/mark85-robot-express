*** Settings ***
Documentation        Cenários de testes do cadastro de usuário

Resource       ../resources/base.resource

Test Setup               Start Session
Test Teardown            Take Screenshot



*** Test Cases ***
Deve poder cadastrar um novo usuário

    ${user}        Create Dictionary      
    ...         name=Salomão David       
    ...         email=david@yahoo.com       
    ...         password=teste@123
  
    Remove user from database    ${user}[email]

    Go to signup page
    Submit signup form        ${user}
    Notice should be          Boas vindas ao Mark85, o seu gerenciador de tarefas.  
   

Não deve permitir o cadastro com email duplicado
    [Tags]    dub

    ${user}        Create Dictionary
     ...    name=David Salomão
     ...    email=david@hotmail.com
     ...    password=teste@123 

    Remove user from database        ${user}[email]
    Insert user from database        ${user}

    Go to signup page
    Submit signup form        ${user}
    Notice should be          Oops! Já existe uma conta com o e-mail informado.

Campos obrigatórios

    [Tags]         required

    ${user}        Create Dictionary
    ...            name=${EMPTY}
    ...            email=${EMPTY}
    ...            password=${EMPTY}

    Go to signup page
    Submit signup form        ${user}

    Alert Should be            Informe seu nome completo
    Alert Should be            Informe seu e-email
    Alert Should be            Informe uma senha com pelo menos 6 digitos

Não deve cadastrar com email incorreto
    [Tags]         inv_email

    ${user}        Create Dictionary
    ...            name=Charles Xavier
    ...            email=xavier.com.br
    ...            password=teste@123

    Go to signup page
    Submit signup form    ${user}
    Alert Should be       Digite um e-mail válido

Não deve cadastrar com senha muito curta
    [Tags]    temp

    @{password_list}    Create List    1    12    123    1234    12345

    FOR    ${password}      IN      @{password_list}
        Log To Console        ${password}
        ${user}        Create Dictionary
    ...            name=Salomão David
    ...            email=salomao@gmail.com
    ...            password=${password}

    Go to signup page
    Submit signup form         ${user}

    Alert Should be            Informe uma senha com pelo menos 6 digitos
    END
    
