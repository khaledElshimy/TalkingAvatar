using UnityEngine;

[CreateAssetMenu(fileName = "ElevenLabsConfig", menuName = "ElvenLabs/ElvenLabs Configuration")]
public class ElevenLabsConfig : ScriptableObject
{
    public string apiKey = "87195fd1361b3626faf6928d6780ce39";
    public string voiceId = "";
    public string ttsUrl = "https://api.elevenlabs.io/v1/text-to-speech/{0}/stream";

}

