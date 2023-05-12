# Diseño de Sistemas Digitales con FPGA

## Resumen

Varios diseños de práctica utilizando una Cyclone II EP2C5 Mini Dev Board.

## Crear un nuevo proyecto

Debido a que el board tiene su configuración própia (dónde estan los leds, cómo
se conectan los pines, etc) hay que configurar todo eso en el proyecto de
Quartus. De no hacerlo el diseño probablemente no funcione en la placa. Para no
hacer todo el proceso una y otra vez se puede crear un proyecto a partir de un
template con el siguiente script.

```
./new_project.sh my_next_gen_console
```

Este template viene con todo configurado para trabajar en un diseño para la
placa EP2C5 Mini Dev y scripts para poder generar y grabar el bytecode (ver
`Makefile` para ver los scripts disponibles).


## Recursos

[Documentación del board: Cyclone II EP2C5 Mini Dev Board](http://land-boards.com/blwiki/index.php?title=Cyclone_II_EP2C5_Mini_Dev_Board)

