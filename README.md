# dest_com
Comando Stata che converte i nomi dei comuni italiani nel codice numerico ufficiale ISTAT.
Per maggiori informazioni leggi il file [dest_com.pdf](https://github.com/NicolaTommasi8/dest_com/blob/master/dest_com.pdf)



Autore
------
  **Nicola Tommasi**  
  _nicola.tommasi@univr.it_  --   _nicola.tommasi@gmail.com_     

  
**Changelog**<br><br>
*! version 2026.01<br>
*!   Comando testato sui dati ISTAT di Dicembre 2025<br>
*!   Comando testato sui dati SITUAS<br>
*!   Aggiunta compatibilità con i comuni a partire dal 1948<br><br><br>
*! version 2025.02<br>
*!   Comando testato sui dati ISTAT di Gennaio 2025<br>
*!   Aggiornata la nomenclatura NUTS alla verione 2024<br>
*!   Modificato il sistema di numerazione della versione<br><br>
*! version 02.2024<br>
*!   aggiornati nuovi comuni 2024 e cambi di denominazione<br><br>
*! version 11.2023<br>
*!   aggiornato nome del comune di Montagna in Montagna sulla strada del vino<br><br>
*! version 01.2023<br>
*!   aggiornati i nuovi comuni del 2023<br><br>
*! version 01.2022<br>
*!   aggiornati i nuovi comuni del 2022<br><br>
*! version 01.2021<br>
*!   aggiornati i nuovi comuni del 2021<br><br>
*! version 01.2020<br>
*!   aggiornati i nuovi comuni del 2020<br><br>
*! version 11.2019<br>
*!   sistemati i cambi di provincia del 1992<br>
*!   minor bugs correction<br><br>
*! version 4.2019<br>
*!   adesso i comuni che hanno cambiato provincia vengono correttamente riconosciuti<br>
*!   completato il label dei nomi dei comuni<br>
*!   se il comando viene lanciato su Stata 16MP dovrebbe essere più veloce<br>
*!   minor bugs correction<br><br>
*! version 3.2019<br>
*!   aggiornati i nuovi comuni del 2019<br>
*!   minor bugs correction<br><br>
*! version 3.2018<br>
*!   aggiornati i nuovi comuni del 2018<br>
*!   minor bugs correction<br><br>
*! version 3.2<br>
*!   aggiornati i nuovi comuni del 2017<br><br>
*! version 3.1<br>
*!   Imposto Stata 13 come versione minima<br>
*!   Uso della funzione ustrfrom() per risolvere problemi legati a database non in formato utf-8 (solo per Stata 14 e successivi  )<br><br>
*! version 3.0<br>
*!   aggiunte le opzioni per creare le variabili<br>
*!     codice provincia istat (gprov)<br>
*!     codice regione istat  (gregio)<br>
*!     codice nuts3 (gnuts3)<br>
*!     codice nuts2 (gnuts2)<br>
*!     codice nuts1 (gnuts1)<br><br>
*! version 2.5<br>
*!   possibilità di fare solo il label dei valori quando la variabile è già numerica<br>
*!   aggiunte le variazioni amministrative del 2016<br>
*!   introdotta l'opzione time: x esempio Campiglia Cervo fino al 2015 ha codice 96011, dal 2016 ha codice 96086<br><br>
*! version 2<br>
*!   eliminata la  necessità di installare il comando unlabeld<br>
*!   creazione file di help<br>
*!   aggiornato elenco comuni al 30/01/2015<br><br>
*! version 1.1.0  06nov2014 aggiunta opzione ignore<br><br>
*! version 1.0.0  02oct2014<br>
*!   tutte le variabili usate nel comando sono di tipo tempvar<br>
*!   introduzione  di contract _CLONE e successivo merge<br>
*!   di fatto parallel non serve più (eliminata la relativa opzione)<br>
*!   correzioni nel riconoscimento di alcuni comuni<br>
*!   eliminazione di codebook, problems che per dataset molto numerosi poteva allungare i tempi di esecuzione<br>
*!   il label della variabile con i codici dei comuni corrisponde al nome della variabile stessa<br><br>
*! version 0.0.1  TomaHawk  27aug2014<br>

