#!/bin/bash

function check() 
{
	if [ $1 -ne 0 ]; then
		err ${@:3}
		exit
	else
		if [ "$2" != "" ]; then
			echo $2
		fi
	fi
}

function listselect() 
{
	local -n list=$1
	list+=("Справка" "Выход")
	select opt in "${list[@]}"; do
	case $opt in
		Выход) return 0;;
		Справка) echo "$2";;
		*)
			if [[ -z $opt ]]; then
				echo "Ошибка: введите число из списка" >&2
			else
				return $REPLY
			fi
			;;
	esac
	done
}

function SearchEvents()
{
    read -p "Тип события (если пусто, то ALL): " eventtype
		if [ "$eventtype" == "" ]; then
			eventtype=ALL
		fi
		read -p "Введите uid пользователя (может быть пустым): " userid
		read -p "Введите строку поиска: " searchstring
		if [ "$search" == "" ]; then
			search="="
		fi
		if [ "$userid" == "" ]; then
			ausearch -m $eventtype | grep $search -B 2
		else
			ausearch -m "$eventtype" -ui "$userid" | grep "$search" -B 2
		fi
}



function AuditReports()
{
    report=""
		echo "Выберите интересующую информацию: "
		select opt in "Отчёт о входе пользователей в систему" "Отчёт о нарушениях" "Справка" "Назад"; do
            case $opt in
            "Отчёт о входе пользователей в систему")
				report="-au"
                break
                ;;
            "Отчёт о нарушениях")
				report="--failed --user"
                break
                ;;
            "Справка")
                echo "Выбирете отчёт"
                ;;
            "Назад")
                break
                ;;
	        *) echo "Неправильная команда $REPLY";;
		esac
		done
		[ "$report" == "" ] && continue
		period=""
		echo "Выберите интересующий период: "
		select opt in "1 день" "неделя" "месяц" "год" "Справка" "Назад"; do
		case $opt in
            "1 день")
				period="today"
                break
                ;;
            "неделя")
				period="this-week"
                break
                ;;
            "месяц")
				period="this-month"
                break
                ;;
            "год")
				period="this-year"
                break
                ;;
            "Справка")
                echo "Выбирете интересующий период отчета"
                ;;
            "Назад")
                break
                ;;
	        *) echo "Неправильная команда $REPLY";;
		esac
		done
		[ "$period" == "" ] && continue

		aureport $report -ts "$period" > report
		check $? "Отчёт сохранен в файл report" "Ошибка сохранения отчета"
}

if [[ "$1" == "--help" ]];
then
    echo "Сценарий "Управление событиями безопасности, аудит.""
	exit
fi

if [ "$EUID" -ne 0 ]; then
	echo "Запустите программу с правами администратора" >&2
	exit
fi

if [[ "$1" != "" ]];
then
	echo "usage: sudo ./FileSystemsManagement.sh [--help]" >&2
	exit
fi

while true
do
	echo -e "\nГлавное меню\n\n`
	`1. Поиск событий аудита\n`
	`2. Отчёты аудита\n`
	`3. Настройка подсистемы аудита для наблюдения за файлами\n`
	`4. Справка\n`
	`5. Выход\n"
	read -p "> " option
	case "$option" in
		1)
		    SearchEvents	
		;;
		2)
			AuditReports
		;;
		3)
            echo Пока не реализовано
		;;
		4)
			echo Выберете номер действия из списка
		;;
		5)
			break
		;;
		*)
			echo -e "Введите число из списка!\n" >&2
        ;;
	esac
done
