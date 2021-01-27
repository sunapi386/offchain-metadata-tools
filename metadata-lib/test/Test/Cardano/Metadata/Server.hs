{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE QuasiQuotes #-}

module Test.Cardano.Metadata.Server
  ( tests
  , testsFns
  ) where

import           Data.List (delete, find, sort)
import           Control.Monad.IO.Class (liftIO)
import           Servant.API
import           Data.Traversable
import           Data.Functor.Identity (Identity(Identity))
import           Data.Proxy (Proxy(Proxy))
import           Data.Text (Text)
import           Data.Word
import qualified Data.ByteString.Lazy.Char8 as BLC
import qualified Data.Text as T
import qualified Data.Aeson as Aeson
import           Text.Read (readEither)
import           Text.RawString.QQ
import           qualified Data.HashMap.Strict as HM
import           Hedgehog (Gen, MonadTest, annotate, forAll, property, tripping, (===), footnote, failure)
import qualified Hedgehog as H (Property)
import qualified Hedgehog.Gen as Gen
import qualified Hedgehog.Range as Range
import qualified Data.Aeson as Aeson
import qualified Data.Aeson.Encode.Pretty as Aeson
import Data.Aeson (ToJSON, FromJSON)
import           Test.Tasty (TestTree, testGroup)
import           Test.Tasty.Hedgehog
import           Test.Tasty.HUnit (Assertion, assertEqual, testCase, (@?=))
import Test.Tasty.Hspec
import qualified Network.Wai.Handler.Warp         as Warp
import Servant.Client
import Network.HTTP.Client (newManager, defaultManagerSettings)
import Data.Map.Strict (Map)
import qualified Data.HashMap.Strict as HM
import qualified Data.Map.Strict as M

import qualified Test.Generators as Gen

import Cardano.Metadata.Server
import Cardano.Metadata.Server.Types 
import Cardano.Metadata.Store.KeyValue.Map

withMetadataServerApp :: ReadFns -> (Warp.Port -> IO ()) -> IO ()
withMetadataServerApp readFns action =
  -- testWithApplication makes sure the action is executed after the server has
  -- started and is being properly shutdown.
  Warp.testWithApplication (pure $ webApp readFns) action

-- tests :: IO TestTree
-- tests = do
--   eg <- liftIO $ testSpec "eg" spec_eg
--   pure $
--     testGroup "Servant server tests"
--     [ eg
--     ]

-- spec_eg :: Spec
-- spec_eg = do
--   let
--     testData = M.fromList
--       [ ("3", Entry $ EntryF "3" (Identity $ Owner mempty mempty) (Identity $ Property "n" []) (Identity $ Property "d" []) (Identity $ PreImage "x" SHA256))
--       ]
        
--   around (withMetadataServerApp (readFnsSimple testData)) $ do
--     let getSubject :<|> getSubjectProperties :<|> getProperty :<|> getBatch = client (Proxy :: Proxy MetadataServerAPI)
--     baseUrl <- runIO $ parseBaseUrl "http://localhost"
--     manager <- runIO $ newManager defaultManagerSettings
--     let clientEnv port = mkClientEnv manager (baseUrl { baseUrlPort = port })

--     describe "GET /subject/{subject}" $ do
--       it "should return the subject" $ \port -> do
--         result <- runClientM (getSubject "3") (clientEnv port)
--         result `shouldBe` (Right $ Entry $ EntryF "3" (Identity $ Owner mempty mempty) (Identity $ Property "n" []) (Identity $ Property "d" []) (Identity $ PreImage "x" SHA256))
--     describe "GET /subject/{subject}/properties" $ do
--       it "should return the subject" $ \port -> do
--         result <- runClientM (getSubject "3") (clientEnv port)
--         result `shouldBe` (Right $ Entry $ EntryF "3" (Identity $ Owner mempty mempty) (Identity $ Property "n" []) (Identity $ Property "d" []) (Identity $ PreImage "x" SHA256))
--     describe "GET /subject/{subject}/property/{property}" $ do
--       it "should return the subject's property" $ \port -> do
--         result <- runClientM (getProperty "3" "owner") (clientEnv port)
--         result `shouldBe` (Right $ PartialEntry $ EntryF "3" (Just $ Owner mempty mempty) Nothing Nothing Nothing)
--     describe "GET /query" $ do
--       it "should return empty response if subject not found" $ \port -> do
--         result <- runClientM (getBatch $ BatchRequest ["3"] ["owner"]) (clientEnv port)
--         result `shouldBe` (Right $ BatchResponse [])
--       it "should return empty response if subject found but property not" $ \port -> do
--         result <- runClientM (getBatch $ BatchRequest ["3"] ["owner"]) (clientEnv port)
--         result `shouldBe` (Right $ BatchResponse [])
--       it "should ignore properties not found, returning properties that were found" $ \port -> do
--         result <- runClientM (getBatch $ BatchRequest ["3"] ["owner"]) (clientEnv port)
--         result `shouldBe` (Right $ BatchResponse [])
--       it "should return a batch response" $ \port -> do
--         result <- runClientM (getBatch $ BatchRequest ["3"] ["owner"]) (clientEnv port)
--         result `shouldBe` (Right $ BatchResponse [])

testsFns :: Gen (KeyValue Word8 Word8) -> TestTree
testsFns genKvs = do
  testGroup "Data store property tests"
    [ testProperty "x" (prop_x genKvs)
    ]

prop_x :: Gen (KeyValue Word8 Word8) -> H.Property
prop_x genKvs = property $ do
  kvs  <- forAll $ genKvs

  let
    newKey = 1
    newValue = 12
  
  kvs' <- liftIO $ write newKey newValue kvs
  original <- liftIO $ toList kvs

  toList kvs' === M.toList (M.insert newKey newValue (M.fromList (toList kvs)))



  
  
