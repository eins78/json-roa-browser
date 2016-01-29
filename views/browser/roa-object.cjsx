React = require('react')
ampersandReactMixin = require('ampersand-react-mixin')
app = require('ampersand-app')
Button = require('react-bootstrap/lib/Button')
ButtonGroup = require('react-bootstrap/lib/ButtonGroup')
ListGroup = require('react-bootstrap/lib/ListGroup')
f = require('../../lib/fun')
deco = require('../lib/decorators')
Icon = require('../icon')
isLocalClick = require('../../lib/local-clicks')
libUrl = require('url')
uriTemplates = require('../../lib/uri-templates')

# TMP: local link handler helper
localLinkHelper = (event, href) ->
  # NOTE: cant use `npm.im/local-links` here because link target is irrelevant:
  return unless isLocalClick(event)
  event.preventDefault()
  app.browser.onRequestSubmit(href)

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

      <ListGroup componentClass='div'>
        <RoaSelfRelation selfRelation={roa.get('roaSelfRelation')} url={roa.baseUrl}/>
        <RoaCollection collection={roa.get('roaCollection')} url={roa.baseUrl}/>
        <RoaRelations relations={roa.get('roaRelations')} url={roa.baseUrl}/>
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
    return null unless collection?.roaRelations.length > 0

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
            <RoaRelationListItem relation={relation} baseUrl={url} key={relation.getId()}/>
          }
        </tbody>
      </table>
    </div>

# 1 row for each Relation in section
RoaRelationListItem = React.createClass
  render: ({relation, baseUrl} = @props)->
    showKey = false

    <tr className='relation-row'>
      {showKey && <td className='col-sm-2'>
        <samp><strong><small>{relation.keyName}</small></strong></samp></td>}
      <td className='title col-sm-2'>
        {relation.title}</td>
      <td className='meta-relations col-sm-4'>
        <ul className='list-inline list-unstyled'>
          {relation.roaRelations.map (metaRel)->
            <li key={metaRel.getId()}>
              <a href={libUrl.resolve(baseUrl, metaRel.href)}>
                <Icon icon='link fa-rotate-90'/>{metaRel.title}</a></li>
          }
        </ul>
      </td>
      <td className='methods col-sm-3'>
        <MethodButtons methods={relation.methods}
          url={relation.href} baseUrl={baseUrl}/></td>
    </tr>

MethodButtons = React.createClass
  render: ({url, methods, baseUrl} = @props)->

    methods = f.mapValues methods, (obj)->
      f.assign obj, if uriTemplates.isTemplated(url)
        templatedUrl: url
      else
        url: libUrl.resolve(baseUrl, url)
    # sort methods like the order defined in styleMap (extra keys at the end)
    methods = deco.sortMethods(methods)

    onMethodSubmit = @props.onMethodSubmit

    <ButtonGroup bsSize='xs'>
      {f.map methods, (obj, method)->
        bsStyle = deco.methodNameToBootstrapeLevel(method)
        isTemplated = obj.templatedUrl?
        # determine if it needs a form at all
        canBeLink = (method is 'get' and isTemplated isnt true)
        # determine if it needs a form (url template or actions needs data)
        needsFormInput = (method isnt 'delete')

        # TMP: dirty: actions here… move this to roa models…
        if canBeLink
          # build a valid link, but intercept "local" clicks (new tabs work!)
          href = libUrl.resolve(baseUrl, url)
          onClick = (event, config) -> localLinkHelper(event, href)
        else
          icon = <Icon icon='pencil-square'/>
          onClick = (event)->
            app.browser.formAction = {
              method: method
              url: obj.url
              templatedUrl: obj.templatedUrl
              defaults: f.defaults app.DEFAULTS.formAction
            }

        <Button href={href} onClick={onClick} bsStyle={bsStyle} key={method}>
          {icon} <samp>{method.toUpperCase()}</samp>
        </Button>
      }
    </ButtonGroup>


ListGroupItem = ({header, children} = @props)->
  <div className='list-group-item'>
    <h4 className='list-group-item-heading'>{header}</h4>
    {children}
  </div>
