package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
)

func main() {
	agent := "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0"
	referer := "https://allmanga.to"
	baseUrl := "https://api.allanime.day/api"
	// animeschedule := "https://animeschedule.net"

	variables_id := `?variables={"mangaId":"bjKg6rj5rh539Wfey","translationType":"sub","chapterString":"1","limit":10,"offset":0}`
	gql_query := `&query=query ($mangaId: String!, $translationType: VaildTranslationTypeMangaEnumType!, $chapterString: String!){chapterPages(mangaId: $mangaId, translationType: $translationType, chapterString: $chapterString) { edges { chapterString pictureUrls pictureUrlsProcessed pictureUrlHead } } }`
	fullUrl := baseUrl + variables_id + gql_query
	fmt.Println(fullUrl)

	client := &http.Client{}

	req, err := http.NewRequest("GET", fullUrl, nil)
	if err != nil {
		fmt.Println(err)
	}

	req.Header.Set("User-Agent", agent)
	req.Header.Set("Referer", referer)

	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println(err)
	}

	// pretty print
	var prettyJSON map[string]interface{}
	err = json.Unmarshal(body, &prettyJSON)
	if err != nil {
		fmt.Println(err)
	}

	prettyOutput, err := json.MarshalIndent(prettyJSON, "", "  ")
	if err != nil {
		fmt.Println(err)
	}

	fileName := "allmanga_id_pages.json"
	err = os.WriteFile(fileName, prettyOutput, 0644) // 0644 is file permissions
	if err != nil {
		fmt.Println(err)
	}

	fmt.Printf("Saved output to file %s\n", fileName)
}
