-- invesettimer.hs

fee = 10
time = 120
rate = 0.04
savings = 1000

data Account = Account Int Int

withInterest :: Int -> Int
withInterest x = round $ growth * fromIntegral x
  where growth = 1 + rate / 12

simulateMonth :: Int -> Account -> Int -> Account
simulateMonth period (Account cash assets) month
  | leftover == 0 = Account 0 transferred
  | otherwise     = Account stored yield
  where deposit     = savings * 100
        stored      = cash + deposit
        transferred = yield + stored - fee * 100
        yield       = withInterest assets
        leftover    = rem month period

simulate :: Int -> Float
simulate period = value $ foldl simulate account months
  where simulate = simulateMonth period
        account = Account 0 0
        months  = [1..time]

value :: Account -> Float
value (Account cash assets) = fromIntegral value / 100
  where value = cash + assets

maxIndex :: (Ord a) => [a] -> Int
maxIndex list = snd . maximum $ zip list [1..]

main = do
  let results = map simulate [1..10]
      topMonth = show . maxIndex $ results
  mapM (putStrLn . show) $ results
  putStrLn $ "It's best to buy every " ++ topMonth ++ " months"
