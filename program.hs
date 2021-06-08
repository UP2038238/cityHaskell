
data City = City{
      name  :: String,
      degreeN  :: Int,
      degreeE  :: Int,
      poplt   :: [Int]
} deriving (Show, Read, Eq)

testData :: [City]
testData =
    [
    City "Amsterdam"   52   5    [1158, 1149, 1140, 1132],
    City "Athens"      38  23    [3153, 3153, 3154, 3156],
    City "Berlin"      53  13    [3567, 3562, 3557, 3552],
    City "Brussels"    51   4    [2096, 2081, 2065, 2050],
    City "Bucharest"   44  26    [1794, 1803, 1812, 1821],
    City "London"      52   0    [9426, 9304, 9177, 9046],
    City "Madrid"      40   4    [6669, 6618, 6559, 6497],
    City "Paris"       49   2    [11079, 11017, 10958, 10901],
    City "Rome"        42  13    [4278, 4257, 4234, 4210],
    City "Sofia"       43  23    [1284, 1281, 1277, 1272],
    City "Vienna"      48  16    [1945, 1930, 1915, 1901],
    City "Warsaw"      52  21    [1790, 1783, 1776, 1768]
    ]

import Data.List
import Text.Printf
import Data.Maybe (isNothing, fromJust)

--q1

allNames :: [City] -> [String]
allNames = map name


--q2

getCitybyName :: String -> [City] -> Maybe City
getCitybyName cityName listOfCities = case filter (\cT -> name cT == cityName) listOfCities of
  [] -> Nothing  -- empty list, no city found, incorrect cityname
  [x] -> Just x  -- one city found


findPopByYr :: Int -> [Int] -> Int
findPopByYr yr poplist = if yr < 0 || length poplist <=yr then 0 else poplist !! yr


returnPop :: Int -> String -> [City] -> String
returnPop yr ctName listOfCities
  | isNothing city = "No data"
  | pop == 0 = "No data"
  | null list = "No data"
  | otherwise = printf "%.3fm" (fromIntegral (findPopByYr yr list) / 1000 :: Float)
  where
    city = getCitybyName ctName listOfCities
    list = poplt (fromJust city)
    pop  = findPopByYr yr list


--q3


twoPopData :: [City] -> String -> String
twoPopData cities@((City name degN degE pop):rest) ctName
    |  ctName == name = printf "%-9s" name ++ "      " ++ printf "%5.2d" degN ++ "N " ++ "   " ++ printf "%3.1d" degE ++ "E " ++ "     " ++  printf "%0.3f" zeroP ++ "m" ++ "     "   ++ printf "%0.3f" oneP ++ "m" ++ "\n"
    |  ctName /= name = twoPopData rest ctName
     where zeroP = fromIntegral(findPopByYr 0 pop) /  1000::Float
           oneP  = fromIntegral(findPopByYr 1 pop) /  1000::Float


twoPopTable :: [City] -> [String]
twoPopTable cities = map mappingFn cities
  where
    mappingFn :: City -> String
    mappingFn oneCity = twoPopData cities (name oneCity)

makeTable :: [City] -> String
makeTable cT = concat (twoPopTable cT)


--q4

-- this function maps newP which is a list of new population into my existing population
updatePop :: [City] -> [Int] -> [City]
updatePop ct newP = zipWith f ct newP
                 where
                 f ct newP = ct {poplt = newP : poplt ct}
--q5

addCity :: City -> [City] -> [City]
addCity new (x:y:xs)
    | null (name new) = x:y:xs
    | name new <= name x = new:x:y:xs
    | name new >=name x && name new <= name y = x:new:y:xs
    | name new >= name y = x:addCity new (y:xs)

--q6

popGrowth :: [City] -> String -> [Int]
popGrowth (c:cs) cTname
    | null cTname = []
    | name c == cTname = poplt c
    | name c /= cTname = popGrowth cs cTname

growths :: [Int] -> [Float]
growths xs =
    zipWith (\n' n -> fromIntegral (n'-n) / fromIntegral n * 100) xs (tail xs)


--q7

distance :: (Int, Int) -> (Int, Int) -> Double
distance (x1, y1) (x2, y2) = sqrt (fromIntegral (x' * x' + y' * y'))
  where
    x' = x1 - x2
    y' = y1 - y2


bigEnough :: City -> Int -> Bool
bigEnough (City _ _ _ (x:xs)) min
    | x<=min = False
    | x>min = True


bigEnoughCities :: [City] -> Int -> [City]
bigEnoughCities [] _ = []
bigEnoughCities (c:cs) min = if bigEnough c min
                             then c: bigEnoughCities cs min
                             else bigEnoughCities cs min



distanceCalc :: Int -> Int -> Int -> [City] -> City
distanceCalc newN newE min cites@((City _ degN degE _):rest) = head (sortOn (\city -> distance (degreeN city , degreeE city) (newN,newE)) cities)
          where cities = bigEnoughCities cites min


--
--  Demo
--

demo :: Int -> IO ()

demo 1 = print (allNames testData)

demo 2 = print (returnPop 2 "Madrid" testData)

demo 3 = putStr (makeTable testData)

demo 4 = putStr (makeTable (updatePop testData [1200,3200,3600,2100,1800,9500,6700,11100,4300,1300,2000,1800] ))

demo 5 = putStr (makeTable (addCity (City "Prague" 50 14 [1312, 1306, 1299, 1292]) testData))

demo 6 = print (growths(popGrowth testData "London"))

demo 7 = print (name (distanceCalc 54 6 2000 testData))

-- demo 8 =  output the population map




--I/O
-- demo refers to testData when being called, deemo is used when main is called, deemo doesn't refer to the testData, but only the loaded data ->cities


main :: IO ()
main = do
  cities <- loadCities
  deemo 1 cities
  mainLoop cities


loadCities :: IO [City]
loadCities = fmap read (readFile "cities.txt")

saveCities :: [City] -> IO ()
saveCities cities =  writeFile "cities.txt" (show cities)


askForInput :: IO Int
askForInput = do
  putStrLn "Please enter a number (1-7) for function demonstrations, q to exit loop:"
  line <- getLine
  case line of
    "q" -> return (-1)
    "1" -> return 1
    "2" -> return 2
    "3" -> return 3
    "4" -> return 4
    "5" -> return 5
    "6" -> return 6
    "7" -> return 7
    _   -> putStrLn "Invalid choice! Please try again :-)" >> askForInput


mainLoop :: [City] -> IO ()
mainLoop cities = do
  inputNumber <- askForInput
  case inputNumber of
    (-1) -> putStrLn "Bye!"
    1 -> deemo 1 cities >> mainLoop cities
    2 -> deemo 2 cities>> mainLoop cities
    3 -> deemo 3 cities>> mainLoop cities
    4 -> deemo 4 cities>> mainLoop cities
    5 -> deemo 5 cities>> mainLoop cities
    6 -> deemo 6 cities>> mainLoop cities
    7 -> deemo 7 cities>> mainLoop cities



deemo :: Int -> [City] -> IO ()

deemo 1 cities = print (allNames cities)

deemo 2 cities = do
          putStrLn "Please enter a number of x years ago, whereby 0 returns the current year's population: "
          yrs <- getLine
          putStrLn "Please enter a city name:"
          ctName <- getLine
          print (returnPop (read yrs) ctName cities)

deemo 3 cities =  putStr (makeTable cities)

deemo 4 cities = do
          putStrLn ("Please enter a new list of population figures for the cities, make sure to include a "++ "[ " ++"]  " ++ "outside of the population figures: ")
          newPoplts <- getLine
          putStr (makeTable (updatePop cities (read newPoplts)))



deemo 5 cities = do
          putStrLn "Please enter a new city name: "
          newCityName <- getLine
          putStrLn "Please enter a new location for the city in terms of DegreeN: "
          newDegN <- getLine
          putStrLn "Please enter a new location for the city in terms of DegreeE: "
          newDegE <- getLine
          putStrLn ("Please enter a new list of population figures for the city, make sure to include a "++ "[ " ++"]  " ++ "outside of the population figures: ")
          newPoplt <- getLine
          putStr (makeTable (addCity (City newCityName (read newDegN) (read newDegE) (read newPoplt)) cities))

deemo 6 cities= do
                putStrLn "Please enter a city name:"
                ctname <- getLine
                print (growths(popGrowth cities ctname))

deemo 7 cities= do
                 putStrLn "Please enter a location in terms of DegreeN: "
                 newDegreeN <- getLine
                 putStrLn "Please enter a location in terms of DegreeE: "
                 newDegreeE <- getLine
                 putStrLn "Please enter the minimum number of current population in millions: "
                 newMin <- getLine
                 print (name (distanceCalc (read newDegreeN) (read newDegreeE) (read newMin) cities))
