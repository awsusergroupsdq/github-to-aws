import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it } from 'vitest'
import App from './App.jsx'

function getSquare(i) {
  return screen.getByRole('button', { name: new RegExp(`^Square ${i}(, (X|O))?$`) })
}

function getStatus() {
  return screen.getByRole('status')
}

async function playMoves(user, moves) {
  for (const move of moves) {
    await user.click(getSquare(move))
  }
}

describe('App', () => {
  it('renders the board with an empty state', () => {
    render(<App />)
    expect(screen.getByRole('heading', { level: 1 })).toHaveTextContent(
      'Tic-Tac-Toe',
    )
    expect(getStatus()).toHaveTextContent('Next player: X')
    for (let i = 1; i <= 9; i++) {
      expect(getSquare(i)).toBeEnabled()
      expect(getSquare(i)).toHaveTextContent('')
    }
  })

  it('marks a square with the current player and passes the turn', async () => {
    const user = userEvent.setup()
    render(<App />)

    const first = getSquare(1)
    await user.click(first)
    expect(first).toHaveTextContent('X')
    expect(first).toBeDisabled()
    expect(getStatus()).toHaveTextContent('Next player: O')
  })

  it('lets O claim a square and marks it after X', async () => {
    const user = userEvent.setup()
    render(<App />)

    await user.click(getSquare(1))
    const second = getSquare(2)
    await user.click(second)
    expect(second).toHaveTextContent('O')
    expect(second).toBeDisabled()
    expect(getStatus()).toHaveTextContent('Next player: X')
  })

  it('ignores clicks on already-taken squares', async () => {
    const user = userEvent.setup()
    render(<App />)

    await user.click(getSquare(1))
    await user.click(getSquare(1))
    expect(getStatus()).toHaveTextContent('Next player: O')
  })

  it('declares X the winner on a top-row win', async () => {
    const user = userEvent.setup()
    render(<App />)

    await playMoves(user, [1, 4, 2, 5, 3])

    expect(getStatus()).toHaveTextContent('Winner: X')
  })

  it('declares O the winner on a diagonal win', async () => {
    const user = userEvent.setup()
    render(<App />)

    // X: 4, 1, 2 / O: 3, 5, 7 anti-diagonal
    await playMoves(user, [4, 5, 1, 3, 2, 7])

    expect(getStatus()).toHaveTextContent('Winner: O')
  })

  it('stops play after a winner is declared', async () => {
    const user = userEvent.setup()
    render(<App />)

    await playMoves(user, [1, 4, 2, 5, 3])

    await user.click(getSquare(9))
    expect(getSquare(9)).toHaveTextContent('')
    expect(getStatus()).toHaveTextContent('Winner: X')
  })

  it('declares a draw when the board fills without a win', async () => {
    const user = userEvent.setup()
    render(<App />)

    // X O X / X X O / O X O — ends in a draw
    await playMoves(user, [1, 2, 3, 5, 4, 7, 6, 9, 8])

    expect(getStatus()).toHaveTextContent('Draw!')
  })

  it('restarts the board and resets the turn', async () => {
    const user = userEvent.setup()
    render(<App />)

    await user.click(getSquare(1))
    await user.click(getSquare(2))

    await user.click(screen.getByRole('button', { name: 'Restart' }))

    for (let i = 1; i <= 9; i++) {
      expect(getSquare(i)).toBeEnabled()
      expect(getSquare(i)).toHaveTextContent('')
    }
    expect(getStatus()).toHaveTextContent('Next player: X')
  })
})
