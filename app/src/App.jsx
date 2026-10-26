import { useState } from 'react'

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

function calculateWinner(squares) {
  for (const [a, b, c] of LINES) {
    if (squares[a] && squares[a] === squares[b] && squares[a] === squares[c]) {
      return squares[a]
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

function Board({ squares, onSquareClick }) {
  return (
    <div className="board">
      {squares.map((value, i) => (
        <button
          key={i}
          type="button"
          className={`square${value ? ` square--${value.toLowerCase()}` : ''}`}
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
  const winner = calculateWinner(squares)
  const isDraw = !winner && squares.every((value) => value !== null)
  const xIsNext = currentMove % 2 === 0

  function handleSquareClick(i) {
    if (winner || squares[i]) return
    const next = squares.slice()
    next[i] = xIsNext ? 'X' : 'O'
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
          <Board squares={squares} onSquareClick={handleSquareClick} />
        </section>
      </div>
      <button type="button" className="restart" onClick={restart}>
        Restart
      </button>
    </main>
  )
}

export default App
