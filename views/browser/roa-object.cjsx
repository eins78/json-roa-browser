React = require('react')
ampersandReactMixin = require('ampersand-react-mixin')
app = require('ampersand-app')
Button = require('react-bootstrap/lib/Button')
ButtonGroup = require('react-bootstrap/lib/ButtonGroup')
ListGroup = require('react-bootstrap/lib/ListGroup')
ListGroupItem = require('react-bootstrap/lib/ListGroupItem')
f = require('../../lib/fun')
Icon = require('../icon')
isLocalClick = require('../../lib/local-clicks')
libUrl = require('url')
uriTemplates = require('../../lib/uri-templates')

module.exports = React.createClass
  displayName: 'RoaObject'
  mixins: [ampersandReactMixin]

  onClick: (event, config) ->
    # TODO: attach listener for all links here
    # (will catch all the 'Meta' links but not 'Method' buttons)
    # if internalLink then handle link internally
    # <ListGroup onClick={@onClick}>

  render: ()->
    roa = @props.roaObject

    <div className='panel panel-info'>
      <div className='panel-heading'>
        <h3>ROA Object</h3>
      </div>

      <ListGroup>
        <RoaSelfRelation selfRelation={roa.get('roaSelfRelation')} url={roa.url}/>
        <RoaCollection collection={roa.get('roaCollection')} url={roa.url}/>
        <RoaRelations relations={roa.get('roaRelations')} url={roa.url}/>
      </ListGroup>

    </div>

RoaSelfRelation = React.createClass
  render: ()->
    {selfRelation} = @props
    return null unless selfRelation.getId()?

    <ListGroupItem header='Self'>
      <RoaRelationList url={@props.url} relations={[selfRelation]}/>
    </ListGroupItem>

RoaCollection = React.createClass
  render: ()->
    collection = @props.collection
    return null unless collection?.roaRelations.length > 1

    <ListGroupItem header='Collection'>
      [next link]
      <RoaRelationList url={@props.url} relations={collection.roaRelations}/>
    </ListGroupItem>

RoaRelations = React.createClass
  render: ()->
    return null unless (relations = @props.relations)?
    <ListGroupItem header='Relations'>
      <RoaRelationList url={@props.url} relations={relations}/>
    </ListGroupItem>

# partials

RoaRelationList = React.createClass
  render: ()->
    {relations, url} = @props
    return null unless relations?.length > 0

    <div className='table-responsive'>
      <table className='table table-striped table-condensed'><thead></thead>
        <tbody>
          {relations.map (relation)->
            <RoaRelationListItem relation={relation} url={url} key={relation.getId()}/>
          }
        </tbody>
      </table>
    </div>

RoaRelationListItem = React.createClass
  render: ()->
    {relation, url} = @props

    console.log relation.serialize() unless url? or relation.href?

    methods = f.mapValues relation.methods, (obj)->
      f.assign {}, obj, if uriTemplates.isTemplated(relation.href)
        templatedUrl: libUrl.resolve(url, relation.href)
      else
        url: libUrl.resolve(url, relation.href)

    console.log methods

    <tr className='relation-row'>
      {false && <td className='col-sm-2'>
        <samp><strong><small>{relation.keyName}</small></strong></samp></td>}
      <td className='title col-sm-2'>
        {relation.title}</td>
      <td className='meta-relations col-sm-4'>
        <ul className='list-inline list-unstyled'>
          {relation.roaRelations.map (metaRel)->
            <li key={metaRel.getId()}>
              <a href={libUrl.resolve(url, metaRel.href)}>
                <Icon icon='link fa-rotate-90'/>{metaRel.title}</a></li>
          }
        </ul>
      </td>
      <td className='methods col-sm-3'>
        <MethodButtons methods={methods}/></td>
    </tr>

MethodButtons = React.createClass
  render: ()->
    styleMap = # bootstrap levels
      get: 'success'
      post: 'primary'
      put: 'info'
      patch: 'info'
      delete: 'danger'

    # sort methods like the order defined in styleMap (extra keys at the end)
    methods = f(@props.methods).sortKeysLike(f.keys(styleMap))

    onMethodSubmit = @props.onMethodSubmit

    <ButtonGroup bsSize='xs'>
      {f.map methods, (obj, key)->
        bsStyle = styleMap[key] or 'warning'
        isTemplated = obj.templatedUrl?
        # determine if it needs a form (url template or actions needs data)
        needsFormInput = isTemplated or not f.includes(['get', 'delete'], key)

        # TMP: dirty: actions here… move this to roa models…
        if needsFormInput
          icon = <Icon icon='pencil-square'/>
          onClick = (event)->
            app.browser.formAction = {
              method: key.toUpperCase(),
              url: obj.url
              templatedUrl: obj.templatedUrl
            }
        else
          href = obj.url # makes it a valid link!
          onClick = (event, config) ->
            # Only handle click meant to be internal by user:
            # NOTE: cant use `local-links` here because link target is irrelevant.
            return unless isLocalClick(event)
            event.preventDefault()
            app.browser.onRequestSubmit(href)

        <Button href={href} onClick={onClick} bsStyle={bsStyle} key={key}>
          {icon} <samp>{key.toUpperCase()}</samp>
        </Button>
      }
    </ButtonGroup>
