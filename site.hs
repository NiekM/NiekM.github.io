{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}

import Hakyll

config :: Configuration
config = defaultConfiguration { destinationDirectory = "docs" }

main :: IO ()
main = hakyllWith config do
  match "images/*" do
    route   idRoute
    compile copyFileCompiler

  match "css/*" do
    route   idRoute
    compile compressCssCompiler

  match (fromList ["index.md", "about.md", "contact.md"]) do
    route   $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match "templates/*" $ compile templateCompiler
