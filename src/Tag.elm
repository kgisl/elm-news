module Tag exposing (TagInfo, view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Dict
import Reddit
import HackerNews
import Analytics


type alias TagInfo =
    { name : String
    , tagColor : String
    , link : String
    }


view : String -> Html Analytics.Msg
view name =
    let
        tag =
            lookupTagInfo name
    in
        div
            [ class <| "tag " ++ tag.tagColor
            , Analytics.onLinkClick
                <| Analytics.TagLink tag.name tag.link
            ]
            [ text tag.name ]


lookupTagInfo : String -> TagInfo
lookupTagInfo name =
    let
        default =
            TagInfo "unknown" "grey" ""

        lookup =
            Dict.empty
                |> Dict.insert "elm-discuss" elmDiscussTag
                |> Dict.insert "elm-dev" elmDevTag
                |> Dict.insert Reddit.tag redditTag
                |> Dict.insert HackerNews.tag hackerNewsTag
    in
        Maybe.withDefault default (Dict.get name lookup)


elmDiscussTag : TagInfo
elmDiscussTag =
    { name = "elm-discuss"
    , tagColor = "elm_light_blue"
    , link = "https://groups.google.com/forum/#!forum/elm-discuss"
    }


elmDevTag : TagInfo
elmDevTag =
    { name = "elm-dev"
    , tagColor = "elm_dark_blue"
    , link = "https://groups.google.com/forum/#!forum/elm-dev"
    }


redditTag : TagInfo
redditTag =
    { name = Reddit.tag
    , tagColor = "elm_yellow"
    , link = "https://www.reddit.com/r/elm/new"
    }


hackerNewsTag : TagInfo
hackerNewsTag =
    { name = HackerNews.tag
    , tagColor = "elm_green"
    , link = "https://hn.algolia.com/?query=elm&sort=byDate&prefix=false&page=0&dateRange=all&type=story"
    }
