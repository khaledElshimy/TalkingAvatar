using System.Net.Mime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using System;
using UnityEngine.UI;
using UnityEngine.EventSystems;


[Serializable]
public class VoiceSettings
{
    public float stability;
    public float similarity_boost;
}

[Serializable]
public class TTSData
{
    public string text;
    public string model_id;
    public VoiceSettings voice_settings;
}


public class ElevenLabs : MonoBehaviour
{
   public ElevenLabsConfig config;

   [SerializeField]
   private AudioSource audioSource;

   [SerializeField]
   private InputField inputField;

   [SerializeField]
   private Button sendButton;

   [SerializeField]
   private Button clearButton;
     
   [SerializeField]
   private Dropdown dropdown;

    [SerializeField]
    private static VoiceActore voiceActore;

   private void Start() 
   {
    if (config.voiceId != "")
    {
        voiceActore = Voices.GetVoiceActorName(config.voiceId);
    }
    else
    {
        voiceActore = VoiceActore.Alice;
    }

    dropdown.ClearOptions();
    var enumValues = Enum.GetValues(typeof(VoiceActore));
     
    foreach (var value in enumValues)
    {
        dropdown.options.Add(new Dropdown.OptionData((value).ToString()));
    }

    if (config.voiceId != "")
    {
        dropdown.value =  (int)Voices.GetVoiceActorName(config.voiceId);
    }
    else
    {
        dropdown.value = 0;
        config.voiceId = Voices.GetVoiceID(voiceActore);
    }

    dropdown.RefreshShownValue(); 

    dropdown.onValueChanged.AddListener(DropdownValueChanged);
    sendButton.onClick.AddListener(GenerateAndStreamAudio);
    clearButton.onClick.AddListener(clearButtonOnPressed);
   }

    private void clearButtonOnPressed()
    {
        EventSystem.current.SetSelectedGameObject(inputField.gameObject);
        inputField.text = "";
        inputField.caretPosition = 0;

    }

    private void Update() 
    {
        if (!audioSource.isPlaying && sendButton.interactable ==false)
        {
            sendButton.interactable = true;
            dropdown.interactable = true;
        }
    }

    public void GenerateAndStreamAudio()
    {
        if (inputField.text == string.Empty)
        return;

        sendButton.interactable = false;
        dropdown.interactable = false;

        StartCoroutine(GenerateAndStreamAudio(inputField.text));
    }

     public void DropdownValueChanged(int change)
    {
        voiceActore = (VoiceActore)change;
        Debug.Log("1 voiceActore: " + voiceActore);
        config.voiceId = Voices.GetVoiceID(voiceActore);
    }

    public IEnumerator GenerateAndStreamAudio(string text)
    {
    
    string modelId = "eleven_multilingual_v2";
    string url = string.Format(config.ttsUrl, config.voiceId);

    TTSData ttsData = new TTSData
    {
        text = text.Trim(),
        model_id = modelId,
        voice_settings = new VoiceSettings
        {
            stability = 0.5f,
            similarity_boost = 0.8f
        }
    };

    string jsonData = JsonUtility.ToJson(ttsData);
    byte[] bodyRaw = System.Text.Encoding.UTF8.GetBytes(jsonData);

    using (UnityWebRequest request = new UnityWebRequest(url, UnityWebRequest.kHttpVerbPOST))
    {
        request.uploadHandler = new UploadHandlerRaw(bodyRaw);
        request.downloadHandler = new DownloadHandlerAudioClip(new Uri(url), AudioType.MPEG);
        request.SetRequestHeader("Content-Type", "application/json");
        request.SetRequestHeader("xi-api-key", config.apiKey);

        yield return request.SendWebRequest();

        if (request.result != UnityWebRequest.Result.Success)
        {
            Debug.LogError("Error: " + request.error);
            yield break;
        }

        AudioClip audioClip = DownloadHandlerAudioClip.GetContent(request);

        if (audioClip != null)
        {
            audioSource.clip = audioClip; 
            PlayAudio(audioClip);
            // Wait for the audio clip to finish playing
            yield return new WaitForSeconds(audioClip.length * 0.1f);
        }
        else
        {
            // the audio is null so download the audio again
            yield return StartCoroutine(GenerateAndStreamAudio(text));
        }


        // Wait for the audio clip to finish playing
        yield return new WaitForSeconds(audioClip.length);
    
        }
    }

    private void PlayAudio(AudioClip audioClip)
    {
       audioSource.PlayOneShot(audioClip);
    }
}