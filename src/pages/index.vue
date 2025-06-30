<script setup lang="ts">
import roundendSound from '@/assets/roundend.mp3'
import words from '@/data/words.json'

const bgm = new Audio(roundendSound)

const currentWordId = ref<null | number>(null)

const round = ref<{
  correctIds: number[]
  wrongIds: number[]
} | null>()

const currentWord = computed(() => {
  if (currentWordId.value === null || currentWordId.value >= words.length) {
    return null
  }

  return words[currentWordId.value]
})

const seenWordIds = ref<number[]>([])

function nextWord() {
  const unseenIds = words
    .map((_, index) => index)
    .filter(id => !seenWordIds.value.includes(id))

  if (unseenIds.length === 0) {
    return
  }

  const randomIndex = Math.floor(Math.random() * unseenIds.length)
  currentWordId.value = unseenIds[randomIndex]
  seenWordIds.value.push(currentWordId.value)
}

function nextRound() {
  round.value = {
    correctIds: [],
    wrongIds: [],
  }
  seenWordIds.value = []
  currentWordId.value = null
  nextWord()
  setTimeout(() => {
    round.value = null
    bgm.play()
  }, 120_000)
}

function wordCorrect() {
  if (!round.value) {
    return
  }
  if (currentWordId.value !== null) {
    round.value.correctIds.push(currentWordId.value)
  }
  nextWord()
}

function wordWrong() {
  if (!round.value) {
    return
  }
  if (currentWordId.value !== null) {
    round.value.wrongIds.push(currentWordId.value)
  }
  nextWord()
}
</script>

<template>
  <div v-if="round && currentWord" class="flex flex-col items-center justify-center h-full gap-12">
    <h1 class="text-center text-4xl font-bold">
      {{ currentWord.word }}
    </h1>

    <div class="flex flex-col items-center gap-4 text-2xl">
      <h2 v-for="taboo of currentWord.taboos" :key="taboo">
        {{ taboo }}
      </h2>
    </div>

    <div class="flex items-center gap-4">
      <button class="bg-red-600 text-white font-bold px-8 py-6" @click="wordWrong ">
        Wrong
      </button>

      <button class="bg-green-600 text-white font-bold px-8 py-6" @click="wordCorrect">
        Correct
      </button>
    </div>
  </div>

  <div v-else class="flex flex-col items-center justify-center h-full gap-12">
    <button class="bg-blue-600 text-white font-bold px-8 py-6" @click="nextRound">
      Start Round
    </button>
  </div>
</template>
