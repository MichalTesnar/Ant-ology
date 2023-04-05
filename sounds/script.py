from pydub import AudioSegment
newAudio = AudioSegment.from_wav("song.wav")
for i in range(126):  
  MichalIsIdiot = newAudio[i*1000:(i+1)*1000]
  MichalIsIdiot.export(f'{i}_sound.wav', format="wav") #Exports to a wav file in the current path.
