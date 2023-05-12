# Diseño de Sistemas Digitales con FPGA

Varios diseños de práctica utilizando una Cyclone II EP2C5 Mini Dev Board.

## Crear un nuevo proyecto

Debido a que el board tiene su configuración própia (dónde estan los leds, cómo
se conectan los pines, etc) hay que configurar todo eso en el proyecto de
Quartus. De no hacerlo el diseño probablemente no funcione en la placa. Para no
hacer todo el proceso una y otra vez se puede crear un proyecto a partir de un
template con el siguiente script.

```bash
./new_project.sh my_next_gen_console
```

Este template viene con todo configurado para trabajar en un diseño para la
placa EP2C5 Mini Dev y scripts para poder generar y grabar el bytecode (ver
`Makefile` para ver los scripts disponibles).


## Grabar placa usando UrJTAG

Por algún motivo en Ubuntu no está funcionando el programador de Quartus y no
reconoce los dispositivos conectados al JTAG. Por suerte UrJTAG funciona
correctamente y se puede grabar la placa usando la cli.

Para ello primero hay que generar un `.svf` que tenga el binario para grabar la
cadena de dispositivos del JTAG. Eso se hace desde el programador de Quartus en
el menu File. Asegurarse que esté configurado para 3.3V en las opciones al
generar el `sfv`.  (TODO: Agregar comando para esto).

Luego hay que grabar el svf usando el siguiente script.

```bash
# Go to project folder
cd my_next_gen_console
# Kill this monstruosity so the port is free
sudo killall jtagd
# Upload program to the FPGA
jtag program_board.jtag
```

Probablemente hay que cerrar Quartus si `jtagd` no se cierra. Tambien puede que
haya que reiniciar la placa para que pueda ser detectada.


## Recursos

[Documentación del board: Cyclone II EP2C5 Mini Dev Board](http://land-boards.com/blwiki/index.php?title=Cyclone_II_EP2C5_Mini_Dev_Board)

