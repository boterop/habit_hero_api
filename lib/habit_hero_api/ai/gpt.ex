defmodule HabitHeroApi.AI.GPT do
  @moduledoc """
  Module for interacting with the OpenAI GPT API.
  """

  alias OpenaiEx
  alias OpenaiEx.{Chat, ChatMessage}

  @type response :: {:ok, String.t()} | {:error, String.t()}

  @doc """
  Generates a response from the OpenAI GPT API.

  ## Examples

      iex> response = HabitHeroApi.AI.GPT.ask("Hello, how are you?")
      {:ok, "I'm doing well, thank you for asking. How about you?"}

  """
  @spec ask(String.t()) :: response()
  def ask(prompt) do
    agent_prompt = System.get_env("AGENT_PROMPT")

    chat =
      Chat.Completions.new(
        model: "gpt-3.5-turbo",
        messages: [
          ChatMessage.assistant(agent_prompt),
          ChatMessage.user(prompt)
        ]
      )

    create_gpt()
    |> Chat.Completions.create(chat)
    |> case do
      %{"choices" => [%{"message" => %{"content" => content}}]} ->
        {:ok, Jason.decode!(content)}

      %{"error" => %{"message" => error}} ->
        {:error, error}
    end
  end

  defp create_gpt do
    "OPENAI_API_KEY"
    |> System.get_env()
    |> OpenaiEx.new()
  end
end
