// SPDX-License-Identifier: cc-by-1.0
// Proyecto introducción a Smart Contracts en Ethereum
// Jorge y Anairam ITAM 2022

pragma solidity ^0.7.0;

// Contrato inteligente para representar 
// servicios de un despacho de consultoría
contract Servicios {
    // Variables locales
    // El consultor
    string public consultor;

    //quien deployo el contrato
    address public owner=msg.sender;
    
    // El servicio prestado
    string public servConsultoria;
    
    // Las horas de consultoría
    uint public horas;
    
    // Inicializa variables. 
    constructor() {
        consultor = "Gabriel Mar";
        servConsultoria = "Secretario";
        horas = 15;
    }

    modifier onlyOwner{
        require(msg.sender==owner,"Tu no eres el propietario");
        _;
    }



     function getServicio()  public  view returns (string memory, string memory, uint) {
       return (consultor, servConsultoria, horas);
   }    

   // Registra información de un servicio
   function setServicio(string memory _consultor, string memory _servConsultoria, uint _horas) public onlyOwner {
       consultor = _consultor;
       servConsultoria = _servConsultoria;
       horas = _horas;
   }
}