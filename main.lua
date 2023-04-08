function love.load()
  
  playerOneScore = 0
  playerTwoScore = 0

  arenaWidth = 800
  arenaHeight = 600

  shipRadius = 30

  bulletTimerLimit = 0.5
  bulletRadius = 5

  -- Asteroid stages when broken apart
  asteroidStages = {
    {
      speed = 120,
      radius = 15,
    },
    {
      speed = 70,
      radius = 30,
    },
    {
      speed = 50,
      radius = 50,
    },
    {
      speed = 20,
      radius = 80,
    }
  }

  function reset()
    -- Ship physics
    shipOneX = arenaWidth / 4
    shipOneY = arenaHeight / 2
    shipOneAngle = 0

    shipTwoX = (arenaWidth * 1.5) / 2
    shipTwoY = arenaHeight / 2
    shipTwoAngle = 160

    shipOneSpeedX = 0
    shipOneSpeedY = 0

    shipTwoSpeedX = 0
    shipTwoSpeedY = 0

    bullets = {}
    bulletTimer = bulletTimerLimit

    -- Asteroid tables
    asteroids = {
      {
        x = 100,
        y = 100,
      },
      {
        x = arenaWidth - 100,
        y = arenaHeight - 100,
      },
      {
        x = arenaWidth / 2,
        y = arenaHeight / 2,
      },
    }

    -- Asteroid random angle movement
    for asteroidIndex, asteroid in ipairs(asteroids) do
      asteroid.angle = love.math.random() * (2 * math.pi)
      asteroid.stage = #asteroidStages
    end
  end

  reset()
end

function love.update(dt)

  -- Ship controls
  local turnSpeed = 10
  local shipSpeed = 100

  if love.keyboard.isDown('d') then
    shipOneAngle = shipOneAngle + turnSpeed * dt
  end

  if love.keyboard.isDown('a') then
    shipOneAngle = shipOneAngle - turnSpeed * dt
  end

  if love.keyboard.isDown('w') then
    shipOneSpeedX = shipOneSpeedX + math.cos(shipOneAngle) * shipSpeed * dt
    shipOneSpeedY = shipOneSpeedY + math.sin(shipOneAngle) * shipSpeed * dt
  end

  if love.keyboard.isDown('l') then
    shipTwoAngle = shipTwoAngle + turnSpeed * dt
  end

  if love.keyboard.isDown('j') then
    shipTwoAngle = shipTwoAngle - turnSpeed * dt
  end

  if love.keyboard.isDown('i') then
    shipTwoSpeedX = shipTwoSpeedX + math.cos(shipTwoAngle) * shipSpeed * dt
    shipTwoSpeedY = shipTwoSpeedY + math.sin(shipTwoAngle) * shipSpeed * dt
  end

  -- Shooting bullets
  bulletTimer = bulletTimer + dt

  if love.keyboard.isDown('q') then
    if bulletTimer >= bulletTimerLimit then
      bulletTimer = 0

      table.insert(bullets, {
        x = shipOneX + math.cos(shipOneAngle) * shipRadius,
        y = shipOneY + math.sin(shipOneAngle) * shipRadius,
        angle = shipOneAngle,
        timeLeft = 2,
      })
    end
  end

  if love.keyboard.isDown('u') then
    if bulletTimer >= bulletTimerLimit then
      bulletTimer = 0

      table.insert(bullets, {
        x = shipTwoX + math.cos(shipTwoAngle) * shipRadius,
        y = shipTwoY + math.sin(shipTwoAngle) * shipRadius,
        angle = shipTwoAngle,
        timeLeft = 2,
      })
    end
  end

  shipOneAngle = shipOneAngle % (2 * math.pi)
  shipTwoAngle = shipTwoAngle % (2 * math.pi)

  shipOneX = (shipOneX + shipOneSpeedX * dt) % arenaWidth
  shipOneY = (shipOneY + shipOneSpeedY * dt) % arenaHeight

  shipTwoX = (shipTwoX + shipTwoSpeedX * dt) % arenaWidth
  shipTwoY = (shipTwoY + shipTwoSpeedY * dt) % arenaHeight

    -- Collision detection
  local function areCirclesIntersecting(aX, aY, aRadius, bX, bY, bRadius)
    return (aX - bX)^2 + (aY - bY)^2 <= (aRadius + bRadius)^2
  end

  -- Bullets
  for bulletIndex = #bullets, 1, -1 do
    local bullet = bullets[bulletIndex]

    bullet.timeLeft = bullet.timeLeft - dt

    if bullet.timeLeft <= 0 then
      table.remove(bullets, bulletIndex)
    else
      local bulletSpeed = 500
      bullet.x = (bullet.x + math.cos(bullet.angle) * bulletSpeed * dt)
        % arenaWidth
      bullet.y = (bullet.y + math.sin(bullet.angle) * bulletSpeed * dt)
        % arenaHeight
    end

    -- Bullets hitting ships
    if areCirclesIntersecting(
      bullet.x, bullet.y, bulletRadius,
      shipOneX, shipOneY, shipRadius
    ) then
      playerTwoScore = playerTwoScore + 2
      reset()
    end

    if areCirclesIntersecting(
      bullet.x, bullet.y, bulletRadius,
      shipTwoX, shipTwoY, shipRadius
    ) then
      playerOneScore = playerOneScore + 2
      reset()
    end

    -- Bullets shooting asteroids
    for asteroidIndex = #asteroids, 1, -1 do
      local asteroid = asteroids[asteroidIndex]

      if areCirclesIntersecting(
        bullet.x, bullet.y, bulletRadius,
        asteroid.x, asteroid.y,
        asteroidStages[asteroid.stage].radius
      ) then
        table.remove(bullets, bulletIndex)

        -- Breaking apart asteroids
        if asteroid.stage > 1 then
          local angle1 = love.math.random() * (2 * math.pi)
          local angle2 = (angle1 - math.pi) % (2 * math.pi)

          table.insert(asteroids, {
            x = asteroid.x,
            y = asteroid.y,
            angle = angle1,
            stage = asteroid.stage -1,
          })
          table.insert(asteroids, {
            x = asteroid.x,
            y = asteroid.y,
            angle = angle2,
            stage = asteroid.stage - 1,
          })
        end

        table.remove(asteroids, asteroidIndex)
        break
      end
    end
  end

  -- Move asteroids
  for asteroidIndex, asteroid in ipairs(asteroids) do
    asteroid.x = (asteroid.x + math.cos(asteroid.angle)
      * asteroidStages[asteroid.stage].speed * dt) % arenaWidth
    asteroid.y = (asteroid.y + math.sin(asteroid.angle)
      * asteroidStages[asteroid.stage].speed * dt) % arenaHeight

    -- Asteroids colliding with ships
    if areCirclesIntersecting(
      shipOneX, shipOneY, shipRadius,
      asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius
    ) then
      if playerOneScore > 0 then
        playerOneScore = playerOneScore - 1
      end
      reset()
      break
    end

    if areCirclesIntersecting(
      shipTwoX, shipTwoY, shipRadius,
      asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius
    ) then
      if playerTwoScore > 0 then
        playerTwoScore = playerTwoScore - 1
      end
      reset()
      break
    end
  end

  -- Ships colliding with each other
  if areCirclesIntersecting(
     shipOneX, shipOneY, shipRadius,
     shipTwoX, shipTwoY, shipRadius
  ) then
     reset()
  end
end


function love.draw()

  for y = -1, 1 do
    for x = -1, 1 do

      love.graphics.origin()
      love.graphics.translate(x * arenaWidth, y * arenaHeight)

      -- Draw ships
      love.graphics.setColor(0, 0, 1)
      love.graphics.circle('fill', shipOneX, shipOneY, shipRadius)

      love.graphics.setColor(1, 1, 0)
      love.graphics.circle('fill', shipTwoX, shipTwoY, shipRadius)

      local shipCircleDistance = 20
      love.graphics.setColor(0, 1, 1)
      love.graphics.circle(
        'fill',
        shipOneX + math.cos(shipOneAngle) * shipCircleDistance,
        shipOneY + math.sin(shipOneAngle) * shipCircleDistance,
        5
      )

      love.graphics.setColor(1, 0, 0)
      love.graphics.circle(
        'fill',
        shipTwoX + math.cos(shipTwoAngle) * shipCircleDistance,
        shipTwoY + math.sin(shipTwoAngle) * shipCircleDistance,
        5
      )

      -- Draw bullets
      for bulletIndex, bullet in ipairs(bullets) do
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle('fill', bullet.x, bullet.y, bulletRadius)
      end

      -- Draw asteroids
      for asteroidIndex, asteroid in ipairs(asteroids) do
        love.graphics.setColor(1, 0, 1)
        love.graphics.circle('fill', asteroid.x, asteroid.y,
          asteroidStages[asteroid.stage].radius)
      end

      love.graphics.setColor(1, 1, 1)
      love.graphics.print('Player One: '..playerOneScore, 0, 0)
      love.graphics.print('Player Two: '..playerTwoScore, 0, 10)
    end
  end
end