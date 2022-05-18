# Getting started

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `FIXER_API_KEY=your-api-key mix phx.server` or inside IEx with `FIXER_API_KEY=your-api-key iex -S mix phx.server`

Now you can convert amounts of money making POST requests to the API:

```sh
curl --request POST \
  --url http://localhost:4000/convert \
  --header 'Content-Type: application/json' \
  --data '{"amount": 1.0, "from": "USD", "to": "BRL"}'
```

The API will respond with status 200 when everything works and with 422 when any attribute is invalid.

## Testing

  * Run the test suite with `mix test`
  * Run credo with `mix credo --strict`
