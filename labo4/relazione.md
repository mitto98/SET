# Autori
Mattia Dapino
Iacopo Filiberto

#Debug validazione multithreading
Per verificare il corretto funzionamento del multithread abbiamo usato il tool jMeter, 
in modo da poter creare un gran numero di connessioni simultanee versoil server e, 
in questo modo, testare la risposta del server a pieno carico.

Abbiamo notato una particolarità presente sia nel browser Firefox che in Chrome, ossia,
al termine del caricamento delle risorse richieste il browser non termina la connessione, 
come previsto dal protocollo HTTP 1.1, ma attende la chiusura della scheda o il passaggio ad 
un altro host, probabilmente per accelerare la velocità di caricamento della pagine successive.

Supponiamo che questo comportamento sia dovuto alla variazione del modo di uso del web,
mentre prima, per via della lentezza di connessione, il cambiamento di pagina era ben ponderato 
(quindi meno frequente), oggi, è più 'conveniente' tornare indietro, quindi effettuare più cambia pagina, 
rendendo vantaggioso mantenere il socket aperto.

Per via di questa particolarità, il solo test da browser non è stato sufficiente siccome era
troppo complicato fare molte richieste su connessioni diverse e diventava quasi impossibile testare
la funzione join_all_threads.

Il seguito al primo test dopo 8 (MAX_CONNECTIONS) richieste separate si verificava un deadlock, 
siccome l'ultimo thread di connessione cercava di joinare se stesso.