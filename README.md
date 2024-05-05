# Progetto di Reti Logiche 2023

## Introduzione
Il progetto realizzato mira a implementare un componente VHDL per gestire un sistema di lettura e scrittura in memoria, basato su specifiche di interfacciamento e comportamento dettagliate. L'elaborazione avviene in diverse fasi che coinvolgono lettura seriale, gestione di indirizzi di memoria e trasmissione di dati.

### Interfaccia Esterna
Il sistema utilizza diverse porte di input e output per interfacciarsi con l'ambiente esterno, tra cui segnali di clock (`i_clk`), reset asincrono (`i_rst`), input seriale (`i_w`), start (`i_start`), oltre a vari segnali per la comunicazione con la memoria e l'output dei risultati.

### Comportamento del Sistema
Il funzionamento si articola in diverse fasi:
1. **IDLE**: Attesa dell'attivazione.
2. **Lettura Seriale**: Acquisizione di identificativi e indirizzi da `i_w`.
3. **Lettura da Memoria**: Lettura dei dati da memoria.
4. **Trasmissione in Uscita**: Emissione dei dati e segnalazione del termine elaborazione.

## Architettura
Il design è strutturato in moduli funzionali interconnessi per realizzare il comportamento desiderato, incluso una macchina a stati finiti (FSM) che governa le transizioni tra le varie fasi di elaborazione. I componenti principali includono:
- **Flip-Flops**: Per memorizzare gli identificativi delle uscite.
- **Left-Shifter**: Per gestire gli indirizzi di memoria.
- **Registri e Mux**: Per immagazzinare e selezionare i dati da mostrare.

## Risultati Sperimentali
Il sistema è stato testato attraverso simulazioni per verificare il corretto funzionamento in vari scenari operativi, inclusi casi limite di lunghezza dei dati in ingresso e gestione di reset asincroni.

## Conclusioni
Il componente ha superato tutti i test effettuati, dimostrando l'affidabilità e l'efficacia dell'implementazione. Le sfide principali riguardavano la sincronizzazione tra i segnali, superate tramite un'accurata progettazione della FSM e l'uso di segnali interni per rappresentare le funzioni di lettura e gestione dello stato.

## File nel Repository
- [RetiLogiche.vhd](RetiLogiche.vhd): File principale che contiene l'implementazione del sistema.
- [report.pdf](report.pdf): Report dettagliato del progetto.

## Studente
- **Nome**: Angelo Antona

