// SPDX-License-Identifier: cc-by-1.0
// Proyecto introducción a Smart Contracts en Ethereum
// Jorge y Anairam ITAM 2022

pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./getEthPrice.sol";

// Contrato inteligente para representar 
// servicios de un despacho de consultoría
contract Servicios is ERC20, getEthPrice{
    // Variables locales
    //quien deployo el contrato
    address public owner=msg.sender;
    address[16] public porPagar;
    uint256 contratosPorPagar=0;
    uint256 TokensPorHora =2;

    struct  ServicioConsultoria {
        string  consultor;
        string  servConsultoria;
        uint  horas;
        bool pagado ;
    }

    mapping(address => ServicioConsultoria) public mappingServicios;
    ServicioConsultoria public serv;

    // Inicializa variables. 
     constructor() ERC20("Servicio de Consultoria Token", "SCTK") {
         uint256 tokenPriceUSD = 10*10**8; 
        _mint(msg.sender, 100000 * 10**2);
    }

     function decimals() public view virtual override returns (uint8) {
        return 2;
    }

    modifier onlyOwner{
        require(msg.sender==owner,"Tu no eres el propietario");
        _;
    }

    function cobrarServicio() public {
        porPagar[contratosPorPagar]=msg.sender;
        contratosPorPagar=contratosPorPagar+1;
    }
      function getUltimoServicioPorPagar()  public  view returns (ServicioConsultoria memory)  {
          
       return (mappingServicios[porPagar[0]]);
   }   

   function autorizarPago(bool siAutorizo) public payable onlyOwner{
       if (siAutorizo){
           if (!mappingServicios[porPagar[0]].pagado){
           uint256 cantidad = getHonorarios();
           require(cantidad *10 **2 <= balanceOf(msg.sender));
           _transfer(msg.sender,porPagar[0] , cantidad * 10 **2);
           mappingServicios[porPagar[0]].pagado=true;
           }
       }
       porPagar[0]=porPagar[15];
        porPagar[0]=porPagar[contratosPorPagar-1];
        contratosPorPagar=contratosPorPagar-1;
   }

   function getHonorarios() public view returns(uint ){
       return((mappingServicios[porPagar[0]].horas)*TokensPorHora);
   }
     function getServicioActual(address direccion )  public  view returns (string memory, string memory, uint,bool)  {
         
       return (mappingServicios[direccion].consultor, mappingServicios[direccion].servConsultoria,
        mappingServicios[direccion].horas,mappingServicios[direccion].pagado);
   }   

   // Registra información de un servicio
   function setServicioActual(address  _addConsultor, string memory _consultor, string memory _servConsultoria, uint _horas) public onlyOwner   {
       ServicioConsultoria storage s = mappingServicios[_addConsultor];
       s.consultor=_consultor;
        s.servConsultoria=_servConsultoria;
        s.horas=_horas;
        s.pagado =false;
   }
}