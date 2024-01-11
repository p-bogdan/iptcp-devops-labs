package main

import (
    "encoding/json"
    "strings"
    "fmt"
    "strconv"
    "io/ioutil"
    "math/rand"
    "net/http"
    "os"
    "time"
)

type TrafficTarget struct {
    Url string
}

type TrafficConfig struct {
    Frequency int64
    TargetPool []TrafficTarget
}

type PassthroughEndpoint struct {
    Path string
    Latency int64
    FaultPercentage float64
    Targets []TrafficTarget
}

type PassthroughConfig struct {
    Port string
    Endpoints []PassthroughEndpoint
}

type ResponseEndpoint struct {
    Path string
    Latency int64
    FaultPercentage float64
    Contents string
}

type ResponsesConfig struct {
    Port string
    Endpoints []ResponseEndpoint
}

type LinkConfig struct {
    Traffic TrafficConfig
    Passthrough PassthroughConfig
    Responses ResponsesConfig
}

func main() {

    rand.Seed(time.Now().UnixNano())

    linkConfig, isLinkConfigSet := os.LookupEnv("LINK_CONFIG")

    if !isLinkConfigSet {
        fmt.Println("You need to set the LINK_CONFIG environment variable")
        fmt.Println(`export LINK_CONFIG="{
     \"Responses\": {
        \"Port\": \"8081\",
        \"Endpoints\": [
            {
                \"Path\": \"/backend\",
                \"Latency\": 100,
                \"FaultPercentage\": 10,
                \"Contents\": \"Sample Backend Response\"
            }
        ]
     }
    }"`)
        http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
            fmt.Fprintf(w, "Default message. You need to configure the environment variables.")
        });
        http.ListenAndServe(":8080", nil)
        return
    }

    // json data
    var obj LinkConfig

    // unmarshal it
    err := json.Unmarshal([]byte(linkConfig), &obj)
    if err != nil {
        fmt.Println("error unmarshalling:", err)
    }

    fmt.Printf("Link starting with configuration: %#v\n", obj);

    profile, isProfileSet := os.LookupEnv("PROFILE")

    // default
    if !isProfileSet {
        profile = "Backend"
    }

    if profile == "Backend" {
        fmt.Println("Starting with backend profile")
        handleResponses(obj.Responses)
    } else if profile == "Middle" {
        fmt.Println("Starting with Middle profile")
        handleMiddle(obj.Passthrough)
    } else if profile == "Traffic" {
        fmt.Println("Starting with Traffic profile")
        handleTraffic(obj.Traffic)
    }
}

// simulate traffic
func handleTraffic(config TrafficConfig) {
    for {
        time.Sleep(time.Duration(config.Frequency) * time.Millisecond)

        randomNumber := rand.Intn(len(config.TargetPool))

        target := config.TargetPool[randomNumber]

        fmt.Println("Making request to " + target.Url)
        response, err := http.Get(target.Url)

        if err == nil {

            body, _ := ioutil.ReadAll(response.Body)

            fmt.Println(response.Status + ": " + string(body))
        } else {
            fmt.Println("Error")
            fmt.Println(err);
        }
    }
}

// Provide a backend that responds to requests
func handleMiddle(config PassthroughConfig) {

    for index := 0; index < len(config.Endpoints); index++ {
        endpoint := config.Endpoints[index]

        fmt.Printf("Adding responses endpoint: %#v\n", endpoint);

        http.HandleFunc(endpoint.Path, func(w http.ResponseWriter, r *http.Request) {

            randomNumber := rand.Intn(100)

            if randomNumber < int(endpoint.FaultPercentage) {
                fmt.Println("Simulating failure for " + endpoint.Path)
                w.WriteHeader(http.StatusInternalServerError)
                fmt.Fprintf(w, "Internal Server Error")
            } else {
                fmt.Println("Responding to request at " + endpoint.Path)
                time.Sleep(time.Duration(endpoint.Latency) * time.Millisecond)
                // make request
                randomNumber := rand.Intn(len(endpoint.Targets))

                target := endpoint.Targets[randomNumber]

                fmt.Println("Making request to " + target.Url)
                response, err := http.Get(target.Url)

                if err != nil {
                    w.WriteHeader(http.StatusBadGateway)
                    fmt.Println("Got error performing HTTP request", err)
                    fmt.Fprintf(w, "Bad gateway or other error response making request to passthrough target.")
                    return
                }
                fmt.Println("response Status:", response.Status)
                status, _ := strconv.Atoi(strings.Split(response.Status, " ")[0])
                fmt.Println(status)
                if status >= 500 {
                    w.WriteHeader(http.StatusBadGateway)
                }
                fmt.Fprintf(w, "\nBackend status: " + string(response.Status) + "\n")
                fmt.Println("response Headers:", response.Header)
                body, _ := ioutil.ReadAll(response.Body)
                fmt.Println("response Body:", string(body))

                fmt.Fprintf(w, string(body))
            }
        })
    }

    fmt.Println("Starting server on port " + config.Port + ".")
    http.ListenAndServe(":" + config.Port, nil)
}

// Provide a backend that responds to requests
func handleResponses(config ResponsesConfig) {

    for index := 0; index < len(config.Endpoints); index++ {
        endpoint := config.Endpoints[index]

        fmt.Printf("Adding responses endpoint: %#v\n", endpoint);

        http.HandleFunc(endpoint.Path, func(w http.ResponseWriter, r *http.Request) {

            randomNumber := rand.Intn(100)

            if randomNumber < int(endpoint.FaultPercentage) {
                fmt.Println("Simulating failure for " + endpoint.Path)
                w.WriteHeader(http.StatusInternalServerError)
                fmt.Fprintf(w, "Internal Server Error")
            } else {
                fmt.Println("Responding to request at " + endpoint.Path)
                time.Sleep(time.Duration(endpoint.Latency) * time.Millisecond)
                // succeeded
                fmt.Fprintf(w, endpoint.Contents)
            }
        })
    }

    fmt.Println("Starting server on port " + config.Port + ".")
    http.ListenAndServe(":" + config.Port, nil)
}

