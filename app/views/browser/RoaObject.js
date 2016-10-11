import React from 'react'
import ampersandReactMixin from 'ampersand-react-mixin'
import app from 'ampersand-app'
import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import ListGroup from 'react-bootstrap/lib/ListGroup'
import ListGroupItem from '../lib/ListGroupItem'
import f from 'active-lodash'
import * as deco from '../lib/decorators'
import Icon from '../lib/Icon'
import isLocalClick from '../../lib/local-clicks'
import libUrl from 'url'
import uriTemplates from '../../lib/uri-templates'

// "conf"
const showRelationsKeys = true

// TMP: local link handler helper
function localLinkHelper (event, href) {
  // NOTE: cant use `npm.im/local-links` here because link target is irrelevant:
  if (!isLocalClick(event)) return
  event.preventDefault()
  app.browser.onRequestSubmit(href)
}

const RoaObject = React.createClass({
  displayName: 'RoaObject',
  mixins: [ampersandReactMixin],

  onClick (event, config) {
    // TODO: attach listener for all links here
    // (will catch all the 'Meta' links but not 'Method' buttons)
    // if internalLink then handle link internally
    // <ListGroup onClick={this.onClick}>
  },

  render (roa = this.props.roaObject) {
    const selfRel = roa.get('roaSelfRelation')
    const relations = roa.get('roaRelations')
    const collection = roa.get('roaCollection')
    const allEmpty = (!(selfRel.getId()) &&
      !(f.get(relations, 'length') > 0) &&
      !(f.get(collection, 'roaRelations.length') > 0))

    return (<div className='panel panel-info'>
      <div className='panel-heading'>
        <h3>ROA Object</h3>
      </div>

      <ListGroup componentClass='div'>
        {allEmpty &&
          <ListGroupItem header='No Relations' />}

        <RoaSelfRelation selfRelation={selfRel} url={roa.baseUrl} />
        <RoaCollection collection={collection} url={roa.baseUrl} />
        <RoaRelations relations={relations} url={roa.baseUrl} />

      </ListGroup>

    </div>)
  }
})

export default RoaObject

// partials

const RoaSelfRelation = ({url, selfRelation}) => (
  (!selfRelation || !selfRelation.getId()) ? <noscript /> : (
    <ListGroupItem header='Self'>
      <RoaRelationList url={url} relations={[selfRelation]} />
    </ListGroupItem>))

const RoaCollection = ({collection}) => (
  !(f.get(collection, 'roaRelations.length') > 0) ? <noscript /> : (
    <ListGroupItem header='Collection'>
      <RoaRelationList url={this.props.url} relations={collection.roaRelations} />
      {((nextLink = collection.next.href) => nextLink &&
        <ButtonGroup bsSize='xs'>
          <Button bsStyle='success' bsSize='small'
            href={nextLink}
            onClick={event => localLinkHelper(event, nextLink)}>
            <samp>GET next </samp> <Icon icon='arrow-circle-right' />
          </Button>
        </ButtonGroup>
      )()}
    </ListGroupItem>))

const RoaRelations = ({relations, url}) => (
  !(f.get(relations, 'length') > 0) ? <noscript /> : (
    <ListGroupItem header='Relations'>
      <RoaRelationList url={url} relations={relations} />
    </ListGroupItem>))

const RoaRelationList = ({relations, url}) => (
  <div className='table-responsive'>
    <table className='table table-striped table-condensed'><thead />
      <tbody>
        {relations.map(relation =>
          <RoaRelationListItem relation={relation} baseUrl={url} key={relation.getId()} />
        )}
      </tbody>
    </table>
  </div>)

// 1 row for each Relation in section
const RoaRelationListItem = ({relation, baseUrl}) => (
  <tr className='relation-row' data-relation-name={relation.keyName}>
    {showRelationsKeys && <td className='col-sm-3'>
      {relation.keyName}</td>}
    <td className='title col-sm-4'>
      <span title={relation.keyName}>{relation.title}</span></td>
    <td className='meta-relations col-sm-3'>
      <ul className='list-inline list-unstyled'>
        {relation.roaRelations.map(metaRel =>
          <li key={metaRel.getId()}>
            <a href={libUrl.resolve(baseUrl, metaRel.href)}>
              <Icon icon='link fa-rotate-90' />{metaRel.title}</a></li>
        )}
      </ul>
    </td>
    <td className='methods col-sm-3'>
      <MethodButtons methods={relation.methods}
        url={relation.href} baseUrl={baseUrl} /></td>
  </tr>
)

const MethodButtons = ({url, methods, baseUrl}) => {
  methods = f.mapValues(methods, obj =>
    f.assign(obj, uriTemplates.isTemplated(url)
      ? {templatedUrl: url}
      : {url: libUrl.resolve(baseUrl, url)}))
  // sort methods like the order defined in styleMap (extra keys at the end)
  methods = deco.sortMethods(methods)

  return (
    <ButtonGroup bsSize='xs'>
      {f.map(methods, (obj, method) => {
        const bsStyle = deco.methodNameToBootstrapLevel(method)
        // determine if it needs a form at all
        const canBeLink = (method === 'get' && !obj.templatedUrl)
        // determine if it needs a form (url template or actions needs data)
        // const needsFormInput = (method !== 'delete') TODO: ?

        // TMP: dirty: actions here… move this to roa models…
        let href, onClick, icon
        if (canBeLink) {
          // build a valid link, but intercept "local" clicks (new tabs work!)
          href = libUrl.resolve(baseUrl, url)
          onClick = (event, config) => localLinkHelper(event, href)
          icon = <Icon icon='link fa-rotate-90' />
        } else {
          icon = <Icon icon='pencil-square' />
          onClick = (event) =>
            app.browser.set({formAction: {
              method: method,
              url: obj.url,
              templatedUrl: obj.templatedUrl,
              defaults: f.defaults(app.DEFAULTS.formAction)
            }})
        }
        return (
          <Button href={href} onClick={onClick} bsStyle={bsStyle} key={method}>
            {icon} <samp>{method.toUpperCase()}</samp>
          </Button>
        )
      })}
    </ButtonGroup>
  )
}
