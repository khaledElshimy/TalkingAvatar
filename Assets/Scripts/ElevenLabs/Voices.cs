using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

[Serializable]
public enum VoiceActore
{
Alice,
Charlotte,
Domi,
Glinda,
Lily,
Serena

}

public static class Voices 
{
    public static Dictionary<VoiceActore,string> VoiceActores;
    static Voices()
    {
        VoiceActores = new Dictionary<VoiceActore,string>();
        VoiceActores.Add(VoiceActore.Alice,"Xb7hH8MSUJpSbSDYk0k2");
        VoiceActores.Add(VoiceActore.Charlotte,"XB0fDUnXU5powFXDhCwa");
        VoiceActores.Add(VoiceActore.Domi,"AZnzlk1XvdvUeBnXmlld");
        VoiceActores.Add(VoiceActore.Glinda,"z9fAnlkpzviPz146aGWa");
        VoiceActores.Add(VoiceActore.Lily,"pFZP5JQG7iQjIQuC4Bku");
        VoiceActores.Add(VoiceActore.Serena,"pMsXgVXv3BLzUgSXRplE");
    }

   public static string GetVoiceID(VoiceActore voiceActor)
   {
    Debug.Log("id: "+VoiceActores[voiceActor]);
      return VoiceActores[voiceActor];
   }

     public static VoiceActore GetVoiceActorName(string voiceID)
   {
    return VoiceActores.FirstOrDefault(x => x.Value == voiceID).Key;
   }
}
