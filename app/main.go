package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

var logger = log.New(os.Stdout, "fargatetest ", log.Ldate|log.Ltime|log.Lmicroseconds|log.Lshortfile)

func rootHandler(w http.ResponseWriter, r *http.Request) {
	logger.Println("Received request on /")
	fmt.Fprintf(w, "Hello world!")
}

func livenessHandler(w http.ResponseWriter, r *http.Request) {
	logger.Println("Received request on /liveness")
	fmt.Fprintf(w, "OK")
}

func main() {
	http.HandleFunc("/", rootHandler)
	http.HandleFunc("/liveness", livenessHandler)
	http.ListenAndServe(":8080", nil)
}
