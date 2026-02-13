# Troubleshooting

## “No backend is configured”

If you see a message indicating no backend is configured:

- Open **Settings → Agent**
- Select an agent (local or cloud)
- Fill required fields (host/apiKey/model) and test connection

## “Disconnected” status

- For local agents: verify the local server is running (Ollama/LM Studio).
- For cloud agents: verify API key and host; network access must be available.

## Tool calls never finish / too many iterations

- Lower `maximumIterations` in settings.
- Disable Multivers temporarily.
- Disable heavy tools to isolate the issue.

## Tool execution fails

- If sandbox is enabled, the tool may be blocked by restrictions or timeout.
- Increase sandbox timeout cautiously, or relax restrictions only if you trust the code.

## External API warning appears repeatedly

- This is expected for cloud agents. Verified developers may be able to dismiss it permanently.

## Where to look for logs

If logging is enabled, inspect the log file under:

- `FileLocator imageDirectory / 'chatpharo' / 'log-chatpharo.txt'`
