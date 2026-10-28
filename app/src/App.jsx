import { useEffect, useState } from 'react'

const LINES = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6],
]

function createAudioContext() {
  const Ctx = window.AudioContext || window.webkitAudioContext
  return Ctx ? new Ctx() : null
}

function playNote(ctx, frequency, startAt, duration, type = 'triangle') {
  const osc = ctx.createOscillator()
  const gain = ctx.createGain()
  osc.type = type
  osc.frequency.value = frequency
  gain.gain.setValueAtTime(0.15, ctx.currentTime + startAt)
  gain.gain.exponentialRampToValueAtTime(
    0.001,
    ctx.currentTime + startAt + duration,
  )
  osc.connect(gain)
  gain.connect(ctx.destination)
  osc.start(ctx.currentTime + startAt)
  osc.stop(ctx.currentTime + startAt + duration)
  return osc
}

function playMoveSound(player) {
  const ctx = createAudioContext()
  if (!ctx) return
  playNote(ctx, player === 'X' ? 440 : 330, 0, 0.15).onended = () => ctx.close()
}

function playWinSound() {
  const ctx = createAudioContext()
  if (!ctx) return
  const notes = [
    [523.25, 0],
    [659.25, 0.15],
    [783.99, 0.3],
    [1046.5, 0.45],
  ]
  const oscs = notes.map(([freq, start]) =>
    playNote(ctx, freq, start, 0.25, 'square'),
  )
  oscs[oscs.length - 1].onended = () => ctx.close()
}

function playDrawSound() {
  const ctx = createAudioContext()
  if (!ctx) return
  const notes = [
    [392, 0],
    [329.63, 0.2],
    [261.63, 0.4],
  ]
  const oscs = notes.map(([freq, start]) => playNote(ctx, freq, start, 0.3))
  oscs[oscs.length - 1].onended = () => ctx.close()
}

function calculateWinner(squares) {
  for (const [a, b, c] of LINES) {
    if (squares[a] && squares[a] === squares[b] && squares[a] === squares[c]) {
      return { player: squares[a], line: [a, b, c] }
    }
  }
  return null
}

function Sprig() {
  return (
    <svg
      className="sprig"
      viewBox="0 0 64 100"
      width="38"
      height="60"
      aria-hidden="true"
      focusable="false"
    >
      <g
        fill="none"
        stroke="currentColor"
        strokeWidth="1.6"
        strokeLinecap="round"
        strokeLinejoin="round"
      >
        <path d="M32 96 C 32 64 32 32 32 6" />
        <path d="M32 68 Q 17 64 13 49 Q 28 53 32 68 Z" />
        <path d="M32 52 Q 47 48 51 33 Q 36 37 32 52 Z" />
        <path d="M32 36 Q 17 32 13 17 Q 28 21 32 36 Z" />
        <path d="M32 22 Q 45 18 48 7 Q 37 11 32 22 Z" />
      </g>
    </svg>
  )
}

function Board({ squares, winningLine, onSquareClick }) {
  return (
    <div className="board">
      {squares.map((value, i) => (
        <button
          key={i}
          type="button"
          className={`square${value ? ` square--${value.toLowerCase()}` : ''}${
            winningLine?.includes(i) ? ' square--win' : ''
          }`}
          onClick={() => onSquareClick(i)}
          disabled={value !== null}
          aria-label={`Square ${i + 1}${value ? `, ${value}` : ''}`}
        >
          {value}
        </button>
      ))}
    </div>
  )
}

function App() {
  const [history, setHistory] = useState([Array(9).fill(null)])
  const [currentMove, setCurrentMove] = useState(0)

  const squares = history[currentMove]
  const result = calculateWinner(squares)
  const winner = result?.player
  const winningLine = result?.line
  const isDraw = !winner && squares.every((value) => value !== null)
  const xIsNext = currentMove % 2 === 0

  useEffect(() => {
    if (winner) playWinSound()
    else if (isDraw) playDrawSound()
  }, [winner, isDraw])

  function handleSquareClick(i) {
    if (winner || squares[i]) return
    const player = xIsNext ? 'X' : 'O'
    const next = squares.slice()
    next[i] = player
    playMoveSound(player)
    const nextHistory = history.slice(0, currentMove + 1).concat([next])
    setHistory(nextHistory)
    setCurrentMove(nextHistory.length - 1)
  }

  function restart() {
    setHistory([Array(9).fill(null)])
    setCurrentMove(0)
  }

  return (
    <main className="game">
      <header className="game__head">
        <Sprig />
        <h1 className="title">Tic-Tac-Toe</h1>
        <p className="status" role="status">
          {winner ? <em className="status__accent">Winner: {winner}</em> : null}
          {!winner && isDraw ? <em className="status__accent">Draw!</em> : null}
          {!winner && !isDraw ? (
            <>Next player: {xIsNext ? 'X' : 'O'}</>
          ) : null}
        </p>
      </header>
      <div className="game__park">
        <section className="panel" aria-label="Game board">
          <Board
            squares={squares}
            winningLine={winningLine}
            onSquareClick={handleSquareClick}
          />
        </section>
      </div>
      <button type="button" className="restart" onClick={restart}>
        Restart
      </button>
    </main>
  )
}

export default App
