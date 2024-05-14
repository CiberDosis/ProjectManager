#!/bin/bash

#### Realizado por Andrés Cámara

############################## Colores

green="\e[0;32m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
endColour="\033[0m\e[0m"
blue="\e[0;34m\033[1m"
red="\e[0;31m\033[1m"
yellow="\e[0;33m\033[1m"
gray="\e[0;37m\033[1m"

######################## Ctrl_c
tools() {
 echo -e "\n${yellow}[+]${endColour}${gray} Descargando Herramientas...${endColour}"
 sudo apt update -y > /dev/null 2>&1
 sudo apt upgrade -y  > /dev/null 2>&1 
 sudo apt-get install -y jq > /dev/null 2>&1
 echo -e "${yellow}[+]${endColour}${gray} Inicando programa...${endColour}"
 sleep 1
}
#tools
ctrl_c() {
  echo -e "${red}\n\n[!] Saliendo...${endColour}\n"
  tput cnorm
  exit 1
}
################################################################################################
trap ctrl_c INT
################################################################################################
logo() {
  echo -e "${red}╔═══╗░░░░░░░░░░░░░╔╗░╔═╗╔═╗░░░░░░░░░░░░░░░░░${endClour}"
  echo -e "${red}║╔═╗║░░░░░╔╗░░░░░╔╝╚╗║║╚╝║║░░░░░░░░░░░░░░░░░${endClour}"
  echo -e "${red}║╚═╝╠═╦══╗╚╬══╦══╬╗╔╝║╔╗╔╗╠══╦═╗╔══╦══╦══╦═╗${endClour}"
  echo -e "${red}║╔══╣╔╣╔╗║╔╣║═╣╔═╝║║░║║║║║║╔╗║╔╗╣╔╗║╔╗║║═╣╔╝${endClour}"
  echo -e "${red}║║░░║║║╚╝║║║║═╣╚═╗║╚╗║║║║║║╔╗║║║║╔╗║╚╝║║═╣║░${endClour}"
  echo -e "${red}╚╝░░╚╝╚══╝║╠══╩══╝╚═╝╚╝╚╝╚╩╝╚╩╝╚╩╝╚╩═╗╠══╩╝░${endClour}"
  echo -e "${red}░░░░░░░░░╔╝║░░░░░░░░░░░░░░░░░░░░░░░╔═╝║░░░░░${endClour}"
  echo -e "${red}░░░░░░░░░╚═╝░░░░░░░░░░░░░░░░░░░░░░░╚══╝░░░░░${endClour}\n"
  
}
################################################################################################

clear
logo 
tput civis
echo -e "${green}{+}${endClour}${gray} Bienvenido a la herramienta Project Manager${endClour}${yellow} $USER.${endClour}" ; sleep 2
tput cnorm

################################################################################################
#Variables Globales 
################################################################################################

declare -i parameter_counter+=0
name_dir="Proyectos"
name_tool="Project Manager"

################################################################################################

helpPanel() {
  echo -e "\n${yellow}[+]${endColour} ${green}USO: bash GestorProject.sh -() Proyecto${endColour}"
  echo -e "\n\t ${redColour}{-} ${redColour}Estas en el panel de ayuda.${endColour}"
  echo -e "\n\t${yellow}[ ++ ]${endColour}${red} +) Estas opciones son en base al nuevo proyecto qeu vas a crear${endColour}"
  echo -e "\n\t${yellow}[ ++ ]${endColour}${red} n) Crear un nuevo proyecto.${endColour}"
  echo -e "\n\t${yellow}[ ++ ]${endColour}${red} t) Añadir una nueva tarea${endColour}"
  echo -e "\n\t${yellow}[ ++ ]${endColour}${red} a) Añadir un nueva actividad${endColour}"
  echo -e "\n\t${yellow}[ ++ ]${endColour}${red} p) Listar proyectos${endColour}"
  echo -e "\n\t${yellow}[ ++ ]${endColour}${red} l) Listar tarea${endColour}"
  echo -e "\n\t${yellow}[ ++ ]${endColour}${red} s) Listar actividad${endColour}"
  echo -e "\n\t${yellow}[ ++ ]${endColour}${red} d) Borrar Proyecto ${endColour}"
  echo -e "\n\t${yellow}[ ++ ]${endColour}${red} v) Ver tareas activas/finalizadas/pasadas ${endColour}"
  echo -e "\n\t${yellow}[ ++ ]${endColour}${red} b) Crear Backup ${endColour}"
  echo -e "\n\t${yellow}[ ++ ]${endColour}${red} h) Se te abre este mismo panel de ayuda.${endColour}"
  exit 1
}

################################################################################################

validation_entrada() {
  tput civis
  validation_direc="$(find / -type d -mindepth 1 2> /dev/null | grep "Proyectos" | head -n 1)"
  if [ $validation_direc ]; then
    echo -e "\n${red}[!]${endColour}${gray} Validamos la existencia del directorio de la herramienta.${endColour}"
    echo -e "\n${yellow}[+]${endColour}${gray} Muy bien el directorio${endColour} ${yellow}$name_dir${endColour} ${gray}de la herramienta${endColour} ${blue}$name_tool${endColour} ${gray}existe. Esta es su ubicacion${endColour}\n"
    echo -e "${purple}$(find / -type d 2> /dev/null | grep "Proyectos" | head -n 1)${endColour}"
  else
    #echo -e "\n${red}[!] El directorio${endColour} ${yellow}$name_dir${endColour} ${red}no existe. Generando directorio.${endColour}\n"
    mkdir $name_dir
    #echo -e "\n${yellow}[+]${endColour} ${green}Se ha creado el directorio con el nombre${endColour}${blue} $name_dir${endColour}\n"
    find / -type d -mindepth 1 2> /dev/null | grep "Proyectos" | head -n 1
    tput cnorm
  fi
}

################################################################################################

newNameProyect() {
  validation_entrada
  tput civis
  pull=$(find / -type f -mindepth 1 2> /dev/null | grep "Proyectos/$newNameProyect")
  validation_dir=$(find / -type d -mindepth 1 2> /dev/null | grep "Proyectos/$newNameProyect" | head -n 1)
  validation_direc="$(find / -type d -mindepth 1 2> /dev/null | grep "Proyectos" | head -n 1)"
  if [ -d "$validation_dir" ]; then 
    echo -e "\n${yellow}[+]${endColour} ${gray}El directorio ${endColour}${blue}$newNameProyect${endColour} ${gray}ya existe. Listando...${endColour}" ; sleep 2
    echo -e "${purple}$(cat ~/Proyectos/$newNameProyect/$newNameProyect.json | tr -d '"' | tr -d ',' | tr -d '{}' | tr -d '[]')${endColour}"
    tput cnorm
  else
    cd $validation_direc
    mkdir $newNameProyect
    cd $newNameProyect
    echo -e "\n${yellow}[+]${endColour} ${gray}EL nuevo proyecto es:${endColour} ${blue}$newNameProyect.${endColour}\n"
    find / -type d -mindepth 1 2> /dev/null | grep "Proyectos/$newNameProyect" | head -n 1; sleep 2
    tput cnorm
    echo -e "\n${yellow}[+]${endColour}${gray} Asigna una descripcion al proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read info_project
    echo -e "${yellow}[+]${endColour}${gray} Asigna una fecha de inicio al Proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read fecha_incio
    echo -e "${yellow}[+]${endColour}${gray} Asigna una fecha de fin al Proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read fecha_fin
    echo -e "${yellow}[+]${endColour}${gray} Asigna un responsable al proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read responsable
    echo -e "${yellow}[+]${endColour}${gray} Asigna un estado al proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read status

    echo -e "\n${yellow}[+] Si quieres añadir tareas al proyecto escribe${endColour} ${green}[si]${endColour}${yellow}. De lo contrario escribe${endColour} ${red}[no]${endColour}" && read respuesta_task
    if [ "$respuesta_task" == "si" ]; then
      echo -e "\n"
      echo -e "${yellow}[+]${endColour}${purple} Asigna una tarea al proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read task
      echo -e "${yellow}[+]${endColour}${purple} Asigna una descripcion a la tarea del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read info_task
      echo -e "${yellow}[+]${endColour}${purple} Asigna una fecha de inicio a la tarea del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read fecha_incio_task
      echo -e "${yellow}[+]${endColour}${purple} Asigna una fecha de fin a la tarea del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read fecha_fin_task
      echo -e "${yellow}[+]${endColour}${purple} Asigna los recursos a la tarea del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read resources_task
      echo -e "${yellow}[+]${endColour}${purple} Asigna un estado a la tarea del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read statustasks
      echo -e "\n${yellow}[+] Si quieres añadir Actividades al proyecto escribe${endColour} ${green}[si]${endColour}${yellow}. De lo contrario escribe${endColour} ${red}[no]${endColour}" && read respuesta_act
      if [ "$respuesta_act" == "si" ]; then
        echo -e "\n"
        echo -e "${yellow}[+]${endColour}${turquoise} Asigna una nombre a la actividad de la tarea $task del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read act
        echo -e "${yellow}[+]${endColour}${turquoise} Asigna una descripcion a la actividad de la tarea $task del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read info_act
        echo -e "${yellow}[+]${endColour}${turquoise} Asigna una fecha de inicio a la actividad de la tarea $task del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read fecha_incio_act
        echo -e "${yellow}[+]${endColour}${turquoise} Asigna una fecha de fin a la actividad de la tarea $task del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read fecha_fin_act
        echo -e "${yellow}[+]${endColour}${turquoise} Asigna un estado a la actividad de la tarea $task del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read statusacts
        echo -e "\n"
        tput civis
        # Nombre del archivo de salida
        output_file="$newNameProyect.json"
        # Crear la estructura JSON y escribir en el archivo
        {
          echo '    {'
          echo '        "Proyecto": "'"${newNameProyect}"'",'
          echo '        "Descripcion_Proyecto": "'"${info_project}"'",'
          echo '        "Fecha_Inicio": "'"${fecha_incio}"'",'
          echo '        "Fecha_Fin": "'"${fecha_fin}"'",'
          echo '        "Responsable": "'"${responsable}"'",'
          echo '        "Estado": "'"${status}"'"'

          echo '    },'
          echo '    {'
          echo '        "Tarea": "'"${task}"'",'
          echo '        "Descripcion_task": "'"${info_task}"'",'
          echo '        "Fecha_Inicio_task": "'"${fecha_incio_task}"'",'
          echo '        "Fecha_Fin_task": "'"${fecha_fin_task}"'",'
          echo '        "Recursos_task": "'"${resources_task}"'",'
          echo '        "Estado_task": "'"${statustasks}"'"'
          echo '    },'
          echo '    {'
          echo '        "Actividad": "'"${act}"'",'
          echo '        "Descripcion_act": "'"${info_act}"'",'
          echo '        "Fecha_Inicio_act": "'"${fecha_incio_act}"'",'
          echo '        "Fecha_Fin_act": "'"${fecha_fin_act}"'",'
          echo '        "Estado_act": "'"${statusacts}"'"'
          echo '    }'
        } >> "$output_file"
        echo -e "\n"
        echo -e "${yellow}[+] JSON generado y guardado en${endColour} $output_file"
        echo -e "\n${yellow}[+]${endColour}${gray} Generando estructura:${endColour}\n " ; sleep 2
        cat $newNameProyect.json | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"'
        tput cnorm
      else
        # Nombre del archivo de salida
        output_file="$newNameProyect.json"
        # Crear la estructura JSON y escribir en el archivo
        {
          echo '['
          echo '    {'
          echo '        "Proyecto": "'"${newNameProyect}"'",'
          echo '        "Descripcion_Proyecto": "'"${info_project}"'",'
          echo '        "Fecha_Inicio": "'"${fecha_incio}"'",'
          echo '        "Fecha_Fin": "'"${fecha_fin}"'",'
          echo '        "Responsable": "'"${responsable}"'",'
          echo '        "Estado": "'"${status}"'"'
          echo '    },'
          echo '    {'
          echo '        "Tarea": "'"${task}"'",'
          echo '        "Descripcion_task": "'"${info_task}"'",'
          echo '        "Fecha_Inicio_task": "'"${fecha_incio_task}"'",'
          echo '        "Fecha_Fin_task": "'"${fecha_fin_task}"'",'
          echo '        "Recursos_task": "'"${resources_task}"'",'
          echo '        "Estado_task": "'"${status}"'"'
          echo '    },'
          echo ']'
        } >> "$output_file"
        echo -e "\n"
        echo -e "${yellow}[+] JSON generado y guardado en${endColour} $output_file"
        echo -e "\n${yellow}[+]${endColour}${gray} Generando estructura:${endColour}\n " ; sleep 2
        cat $newNameProyect.json | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"'
        tput cnorm
      fi
    else
      # Nombre del archivo de salida
      output_file="$newNameProyect.json"
      # Crear la estructura JSON y escribir en el archivo
      {
        echo '['
        echo '    {'
        echo '        "Proyecto": "'"${newNameProyect}"'",'
        echo '        "Descripcion_Proyecto": "'"${info_project}"'",'
        echo '        "Fecha_Inicio": "'"${fecha_incio}"'",'
        echo '        "Fecha_Fin": "'"${fecha_fin}"'",'
        echo '        "Responsable": "'"${responsable}"'",'
        echo '        "Estado": "'"${status}"'"'
        echo '    },'
        echo ']'
      } >> "$output_file"
      echo -e "\n"
      echo -e "${yellow}[+] JSON generado y guardado en${endColour} $output_file"
      echo -e "\n${yellow}[+]${endColour}${gray} Generando estructura:${endColour}\n " ; sleep 2
      cat $newNameProyect.json | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"'
      tput cnorm
    fi
  fi
}

################################################################################################

addtask() {
  tput civis
  echo -e "\n${yellow}[+]${endColour} ${gray}Añadir tareas a un proyecto.${endColour}"
  find / -type d -mindepth 1 2> /dev/null | grep "Proyectos" | cut -d '/' -f 5
  comando=$(find / -type d -mindepth 1 2> /dev/null | grep "Proyectos/$newTareaProyect" | cut -d '/' -f 5)
  encontrado=0
  while read -r linea; do
      if [ "$linea" = "$newTareaProyect" ]; then
          encontrado=1
          break
      fi
  done <<< "$comando"
  # Verificar si se encontró la coincidencia
  if [ $encontrado -eq 1 ]; then
    ubi=$(find / -type d -mindepth 1 2> /dev/null | grep "Proyectos/$newTareaProyect" | head -1)
    cd $ubi
    echo -e "\n${yellow}[+]${endColour}${gray} Estas en el proyecto${endColour}${green} $newTareaProyect.${endColour}\n"
    tput cnorm
    echo -e "${yellow}[+]${endColour}${purple} Asigna una tarea al proyecto${endColour} ${blue}$newTareaProyect:${endColour} " && read task
    echo -e "${yellow}[+]${endColour}${purple} Asigna una descripcion a la tarea del proyecto${endColour} ${blue}$newTareaProyect:${endColour} " && read info_task
    echo -e "${yellow}[+]${endColour}${purple} Asigna una fecha de inicio a la tarea del proyecto${endColour} ${blue}$newTareaProyect:${endColour} " && read fecha_incio_task
    echo -e "${yellow}[+]${endColour}${purple} Asigna una fecha de fin a la tarea del proyecto${endColour} ${blue}$newTareaProyect:${endColour} " && read fecha_fin_task
    echo -e "${yellow}[+]${endColour}${purple} Asigna los recursos a la tarea del proyecto${endColour} ${blue}$newTareaProyect:${endColour} " && read resources_task
    echo -e "${yellow}[+]${endColour}${purple} Asigna un estado a la tarea del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read statustask

    tput civis
    # Nombre del archivo de salida
    output_file="$newTareaProyect.json"
    # Crear la estructura JSON y escribir en el archivo
    {
      echo '['
      echo '    {'
      echo '        "Tarea": "'"${task}"'",'
      echo '        "Descripcion_task": "'"${info_task}"'",'
      echo '        "Fecha_Inicio_task": "'"${fecha_incio_task}"'",'
      echo '        "Fecha_Fin_task": "'"${fecha_fin_task}"'",'
      echo '        "Recursos_task": "'"${resources_task}"'"'
      echo '        "Estado_task": "'"${statustask}"'"'
      echo '    },'
      echo ']'
    } >> "$output_file"
    echo -e "\n"
    echo -e "${yellow}[+] JSON generado y guardado en${endColour} $output_file"
    echo -e "\n${yellow}[+]${endColour}${gray} Generando estructura:${endColour}\n " ; sleep 2
    cat $newTareaProyect.json | tr -d ',' | tr -d '"' | tr -d '{}' | tr -d '[]'
    tput cnorm
  else
    echo -e "\n${yellow}[+]${endColour}${red} No se encontró el proyecto '$newTareaProyect'.${endColour}"
    tput cnorm
    exit 1
  fi
}

################################################################################################

addAct() {

  tput civis
  echo -e "\n${yellow}[+]${endColour} ${gray}Añadir Actividades a un proyecto.${endColour}"
  find / -type d -mindepth 1 2> /dev/null | grep "Proyectos" | cut -d '/' -f 5
  comando=$(find / -type d -mindepth 1 2> /dev/null | grep "Proyectos/$newActProyect" | cut -d '/' -f 5)
  encontrado=0
  while read -r linea; do
      if [ "$linea" = "$newActProyect" ]; then
          encontrado=1
          break
      fi
  done <<< "$comando"
  # Verificar si se encontró la coincidencia
  if [ $encontrado -eq 1 ]; then
    ubi=$(find / -type d -mindepth 1 2> /dev/null | grep "Proyectos/$newActProyect" | head -1)
    cd $ubi
    echo -e "\n${yellow}[+]${endColour}${gray} Estas en el proyecto${endColour}${green} $newActProyect.${endColour}\n"
    tput cnorm
    echo -e "${yellow}[+]${endColour}${turquoise} Asigna una nombre a la actividad de la tarea $task del proyecto${endColour} ${blue}$newActProyect:${endColour} " && read act
    echo -e "${yellow}[+]${endColour}${turquoise} Asigna una descripcion a la actividad de la tarea $task del proyecto${endColour} ${blue}$newActProyect:${endColour} " && read info_act
    echo -e "${yellow}[+]${endColour}${turquoise} Asigna una fecha de inicio a la actividad de la tarea $task del proyecto${endColour} ${blue}$newActProyect:${endColour} " && read fecha_incio_act
    echo -e "${yellow}[+]${endColour}${turquoise} Asigna una fecha de fin a la actividad de la tarea $task del proyecto${endColour} ${blue}$newActProyect:${endColour} " && read fecha_fin_act
    echo -e "${yellow}[+]${endColour}${turquoise} Asigna un estado a la actividad de la tarea $task del proyecto${endColour} ${blue}$newNameProyect:${endColour} " && read statusact
    tput civis
    # Nombre del archivo de salida
    output_file="$newActProyect.json"
    # Crear la estructura JSON y escribir en el archivo
    {
      echo '['
      echo '    {'
      echo '        "Actividad": "'"${act}"'",'
      echo '        "Descripcion_act": "'"${info_act}"'",'
      echo '        "Fecha_Inicio_act": "'"${fecha_incio_act}"'",'
      echo '        "Fecha_Fin_act": "'"${fecha_fin_act}"'"'
      echo '        "Estado_act": "'"${statusact}"'"'
      echo '    }'
      echo ']'
    } >> "$output_file"
    echo -e "\n"
    echo -e "${yellow}[+] JSON generado y guardado en${endColour} $output_file"
    echo -e "\n${yellow}[+]${endColour}${gray} Generando estructura:${endColour}\n " ; sleep 2
    cat $newActProyect.json | tr -d ',' | tr -d '"' | tr -d '{}' | tr -d '[]'
    tput cnorm
  else
    echo -e "\n${yellow}[+]${endColour}${red} No se encontró el proyecto '$newTareaProyect'.${endColour}"
    tput cnorm
    exit 1
  
  fi

}

################################################################################################

ProjectList() {
  echo -e "\n${yellow}{+}${endColour}${gray} Estos son todos los proyectos guardados.${endColour}\n"
  for i in $(find / -type f -mindepth 1 2> /dev/null | grep "Proyectos"); do cat $i | grep '^\s*"Proyecto":' -A 5 | tr -d '"' | tr -d ',' | tr -d '{}' | tr -d '[]'; echo -e "\n"; done
  echo -e "\n${yellow}{+}${endColour}${gray} Estos son todos los proyectos terminados.${endColour}\n"
  for i in $(find / -type f -mindepth 1 2> /dev/null | grep "Proyectos"); do cat $i | grep '^\s*"Proyecto":' -A 5 | grep "Terminado" -B 5 | tr -d '"' | tr -d ',' | tr -d '{}' | tr -d '[]' ; echo -e "\n"; done
}

################################################################################################

TaskList() {
  echo -e "\n${yellow}{+}${endColour}${gray} Estos son todas los tareas del Proyecto $listTask.${endColour}\n"
  for i in $(find / -type f -mindepth 1 2> /dev/null | grep "Proyectos/$listTask"); do cat $i | grep '^\s*"Tarea":' -A 5 | tr -d '"' | tr -d ',' | tr -d '{}' | tr -d '[]'; echo -e "\n"; done
  echo -e "\n${yellow}{+}${endColour}${gray} Estos son todas los tareas terminadas de $listTask.${endColour}\n"
  for i in $(find / -type f -mindepth 1 2> /dev/null | grep "Proyectos/$listTask"); do cat $i | grep '^\s*"Tarea":' -A 5 | grep "Terminado" -B 5 |  tr -d '"' | tr -d ',' | tr -d '{}' | tr -d '[]'; done

}

################################################################################################

ActList() {
  echo -e "\n${yellow}{+}${endColour}${gray} Estos son todas las Actividades del Proyecto ${endColour}${blue}$ListAct.${endColour}\n"
  for i in $(find / -type f -mindepth 1 2> /dev/null | grep "Proyectos/$ListAct"); do cat $i | grep '^\s*"Actividad":' -A 4 | tr -d '"' | tr -d ',' | tr -d '{}' | tr -d '[]'; echo -e "\n"; done
  echo -e "\n${yellow}{+}${endColour}${gray} Estos son todas las Actividades terminadas del Proyecto ${endColour}${blue}$ListAct.${endColour}\n"
  for i in $(find / -type f -mindepth 1 2> /dev/null | grep "Proyectos/$ListAct"); do cat $i | grep '^\s*"Actividad":' -A 4 | grep "Terminado" -B 5 | tr -d '"' | tr -d ',' | tr -d '{}' | tr -d '[]'; done

}

################################################################################################

Remove(){
  echo -e "\n${yellow}{+}${endColour}${gray} Borrar seccion del Proyecto:${endColour}${red} $Delete${endColour}\n"
  Filtra=$(find / -type f -mindepth 1 2> /dev/null | grep "Proyectos/$Delete")
  Filtro=$(find / -type d -mindepth 1 2> /dev/null | grep "Proyectos/$Delete")
  cat $Filtra | tr -d ',' | tr -d '"' | tr -d '[]' | tr -d '{}'
  echo -e "\n${red}[!] Para poder borrar una seccion tendras que escribir primero si es tarea, actividad o proyecto y despues indicar el titlo de la tarea, la actividad, o el titulo del proyecto.${endColour}"
  echo -e "\n${yellow}[+]${endColour}${turquoise} Cual es la seccion {Tarea, Actividad, Proyecto (Escribelo igual que aqui) } quieres borrar del proyecto${endColour} ${blue}$Delete:${endColour}\n " && read delete_seccion
  if [ $delete_seccion == "Tarea" ]; then
    cd $Filtro
    echo -e "\n"
    cat $Filtra | grep '^\s*"'$delete_seccion'":' -A 5 -B 1 | tr -d ',' | tr -d '"'
    echo -e "\n${yellow}[+]${endColour}${turquoise} Cual es la parte de $delete_section (Selecciona el titulo de la tarea y escribelo igual) que quieres borrar del proyecto${endColour} ${blue}$Delete:${endColour} " && read delete_sec
    echo -e "\n[+] Mostrando seccion: \n"
    cat $Filtra | grep '^\s*"'$delete_seccion'":' -A 5 -B 1 | grep "$delete_sec" -A 5 -B 1 | tr -d ',' | tr -d '"' | tr -d '{}' | tr -d '[]'
    sed -i '/"Tarea": "'"$delete_sec"'"/{:a;N;/}/!ba;d}' $Delete.json
    jq 'if length > 0 then . else empty end' $Delete.json > "$Delete"_nuevo.json; mv "$Delete"_nuevo.json $Delete.json
    echo -e "\n${red}[!] Seccion Borrada${endColour}\n"
    sleep 2
    cat $Delete.json | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"'
  elif [ $delete_seccion == "Actividad" ]; then
    cd $Filtro
    echo -e "\n"
    cat $Filtra | grep '^\s*"'$delete_seccion'":' -A 4 -B 1 | tr -d ',' | tr -d '"' | tr -d '{}' | tr -d '[]'
    echo -e "\n${yellow}[+]${endColour}${turquoise} Cual es la Actividad de ${endColour}${blue}$Delete${endColour}${turquoise} (Selecciona el titulo y escribelo igual) que quieres borrar:${endColour}\n " && read delete_sec2
    echo -e "\n${yellow}[+]${endColour}${gray} Mostrando seccion:${endColour} \n"
    cat $Filtra | grep '^\s*"'$delete_seccion'":' -A 4 -B 1 | grep "$delete_sec2" -A 4 -B 1 | tr -d ',' | tr -d '"' | tr -d '{}' | tr -d '[]'
    sleep 3    
    sed -i '/"Actividad": "'"$delete_sec2"'"/{:a;N;/}/!ba;d}' $Delete.json
    jq 'if length > 0 then . else empty end' 2> /dev/null $Delete.json > "$Delete"_nuevo.json; mv "$Delete"_nuevo.json $Delete.json
    echo -e "\n${red}[!] Seccion Borrada${endColour}\n"
    sleep 2
    cat $Delete.json | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"'
  elif [ $delete_seccion == "Proyecto" ]; then
    deleteporject=$(find / -type d -mindepth 1 2> /dev/null | grep "Proyectos/$Delete")
    rm -r $deleteporject
    echo -e "\n${yellow}{+}${endColour}${gray} Proyecto${endColour} ${red}$Delete${endColour}${gray} Borrado${endColour}\n"
    sleep 2
    exit 0
  else
    echo "Error"
    sleep 3
    exit 1
  fi
  sleep 5
}

################################################################################################

ActiveTask() {
  Filtra=$(find / -type f -mindepth 1 2> /dev/null | grep "Proyectos/$Active")
  Filtro=$(find / -type d -mindepth 1 2> /dev/null | grep "Proyectos/$Active")
  fechas_proyecto=$(for i in $(find / -type f -mindepth 1 2> /dev/null | grep "Proyectos/$Active"); do cat $i  | grep "Fecha_Fin" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}'; done)
  fecha_actual=$(date +%F)
  status=$(for i in $(find / -type f -mindepth 1 2> /dev/null | grep "Proyectos/$Active"); do cat $i | grep "Estado" | awk 'NF{print $NF}' | tr -d '"'; done)
  cd $Filtro
  echo -e "\n${yellow}{+}${endColour}${gray} Este es el el Proyecto:${endColour}${blue} $Active${endColour}\n"
  cat $Filtra | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"' | grep "Proyecto" | head -1 
  echo -e "\n"
  cat $Filtra | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"' | grep "Tarea"
  echo -e "\n"
  cat $Filtra | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"' | grep "Actividad" 
  echo -e "\n${yellow}[+]${endColour}${gray} Indica la seccion que quuieres ver su estado:${endColour}${blue} (Actividad, Tarea, Proyecto):${endColour} " && read show_status
  echo -e "\n${yellow}[+]${endColour}${gray} Indica el titulo de laseccion que quieres ver su estado:${endColour}${blue} (tit. Actividad, Tarea, Proyecto):${endColour} " && read show_statustit
  Var=$(cat $Filtra | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"' | grep "$show_status: $show_statustit" -A 5 | grep "Fecha_Fin")
  cat $Filtra | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"' | grep "$show_status: $show_statustit" -A 5 | grep "Estado"
  sleep 2
  while read -r linea; do
      if [ "$linea" = "$fecha_actual" ]; then
         for i in "$linea"; do echo -e "\n${yellow}[+]${endColour}${gray} Ha finalizado el plazo o es el ultimo dia. ${endColour}${red} "$i"${endColour}"; done
      fi
      if [ "$linea" != "$fecha_actual" ]; then
         for i in "$linea"; do echo -e "\n${yellow}[+]${endColour}${gray}  NO ha finalizado el plazo. ${endColour}${green} "$i"${endColour}"; done
      fi
  done <<< "$Var"
  echo -e "\n${yellow}[+]${endColour}${gray} Quieres ver el estado de todo el proyecto${endColour}${blue} (proyecto, tarea, act.)${endColour}"
  echo -e "\n${yellow}[+]${endColour}${gray} Escribe:${endColour}${blue} (Comprobar) o presiona Enter para salir: ${endColour}\n" && read val
  if [ "$val" == "Comprobar" ]; then 
    echo -e "\n${yellow}[+]${endColour}${gray} Esto es todo el proyecto con sus fechas y estados${endColour}\n"
    cat $Filtra | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"' | grep "Estado" -B 5
    echo -e "\n${yellow}[+]${endColour}${gray} Escribe:${endColour}${blue} Renombrar si quieres sustituir el estado de los procesos o presiona Enter para salir:${endColour} \n" && read value
    if [ "$value" == "Renombrar" ]; then
      echo -e "${yellow}[+]${endColour}${gray}Escribe el nombre de lo que quieres remplazar${endColour}${red} (Ej: Actividad)${endColour}" && read name
      echo -e "${yellow}[+]${endColour}${gray}Escribe el titulo de lo que quieres remplazar${endColour}${red} (Ej: hola)${endColour}" && read tit
      echo -e "${yellow}[+]${endColour}${gray}Escribe el estado que quieres${endColour}" && read valor
      echo -e "${yellow}[+]${endColour}${gray}Escribe que tipo de estado esta actualemente:${endColour}" && read vall
      echo -e "${yellow}[+]${endColour}${gray}Escribe el valor nuevo${endColour}" && read valor_nuevo
      #sed -i "s|\"$valor\": \"$vall\"|\"$valor\": \"$valor_nuevo\"|g" $Active.json
      cat $Filtra | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"' | grep "$name: $tit" -B 5 | sed -i "s|\"$valor\": \"$vall\"|\"$valor\": \"$valor_nuevo\"|g" $Active.json
      echo -e "\n"
      cat $Filtra | tr -d '{}' | tr -d '[]' | tr -d ',' | tr -d '"' | grep "$name: $tit" -A 4
    else
      echo -e "${red}[!] Saliendo...${endColour}"
      exit
    fi
  else
    echo -e "${red}[!] Saliendo...${endColour}"
    exit
  fi
}
backup() {
  echo -e "\n${yellow}{+}${endColour}${gray} Creando BackUp...${endColour}"
  echo -e "\n${yellow}{+}${endColour}${gray} Establece el nombre del backup:${endColour} \n" && read backup_dir
  local=$(find / -type d -mindepth 1 2> /dev/null | grep "Proyectos" | head -1)
  cp -r $local $backup_dir
  echo -e "\n${yellow}[+]${endColour}${green} Backup creado.${endColour}${blue} Esta es su ubicacion...${endColour}\n"
  find / -type d -mindepth 1 2> /dev/null | grep "$backup_dir" | head -1
}
################################################################################################

while getopts "n:t:a:l:s:d:v:pbh" arg; do
  case $arg in
    n)
      newNameProyect=$OPTARG; let parameter_counter+=1;;
    t)
      newTareaProyect=$OPTARG; let parameter_counter+=2;;
    a)
      newActProyect=$OPTARG; let parameter_counter+=3;;
    l)
      listTask=$OPTARG; let parameter_counter+=4;;
    s)
      ListAct=$OPTARG; let parameter_counter+=5;;
    d)
      Delete=$OPTARG; let parameter_counter+=6;;
    v)
      Active=$OPTARG; let parameter_counter+=7;;
    p)
      let parameter_counter+=8;;
    b)
      let parameter_counter+=9;;
    h)
      helpPanel;;
  esac

done

################################################################################################ 

if [ $parameter_counter -eq 1 ]; then
  newNameProyect 
elif [ $parameter_counter -eq 2 ]; then
  addtask
elif [ $parameter_counter -eq 3 ]; then
  addAct
elif [ $parameter_counter -eq 4 ]; then
  TaskList
elif [ $parameter_counter -eq 5 ]; then
  ActList
elif [ $parameter_counter -eq 6 ]; then
  Remove
elif [ $parameter_counter -eq 7 ]; then
  ActiveTask
elif [ $parameter_counter -eq 8 ]; then
  ProjectList
elif [ $parameter_counter -eq 9 ]; then
  backup
else
  echo -e "\n\t${red}[!] Argumento Invalido.${endColour}"
	exit 1
fi

