module News.View exposing (view)

import Date exposing (Date)
import Html exposing (Html, div, a, text, span)
import Html.Attributes exposing (class, href, id)
import Html.Events exposing (onClick)
import News.Story exposing (Story)
import Analytics exposing (Event)
import News.Tag as Tag
import DateFormatter


type alias Config msg =
    { now : Maybe Date
    , screenWidth : Int
    , onLinkClick : Event -> msg
    }


view : Config msg -> List Story -> Html msg
view config stories =
    stories
        |> List.sortBy .date
        |> List.reverse
        |> List.map (cardView config)
        |> div [ class "cards" ]


cardView : Config msg -> Story -> Html msg
cardView { now, screenWidth, onLinkClick } story =
    let
        attrs =
            if screenWidth < 600 then
                [ Analytics.newsLink story
                    |> onLinkClick
                    |> onClick
                , class "card card__link"
                ]
            else
                [ class "card" ]
    in
        div attrs
            [ Tag.view story.tag onLinkClick
            , div [ class "card__description" ]
                [ linkView story onLinkClick
                , authorView story.author
                ]
            , timeStamp now story.date
            ]


linkView : Story -> (Event -> msg) -> Html msg
linkView story onLinkClick =
    div [ class "card__description__header" ]
        [ a
            [ Analytics.newsLink story
                |> onLinkClick
                |> onClick
            , href story.url
            , class "card__description__title"
            ]
            [ text story.title ]
        , span [ class "card__description__domain" ]
            [ text <| "(" ++ story.domain ++ ")" ]
        ]


authorView : String -> Html msg
authorView author =
    div [ class "card__author" ]
        [ text <| "By " ++ author ]


timeStamp : Maybe Date -> Float -> Html msg
timeStamp now date =
    div [ class "card__date" ]
        [ DateFormatter.format now date
            |> text
        ]
